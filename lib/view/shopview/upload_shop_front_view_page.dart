import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/utils/firestore/shops.dart';

class UploadShopFrontViewPage extends StatefulWidget {
  final Shop shopaccount;

  UploadShopFrontViewPage({required this.shopaccount});

  @override
  _UploadShopFrontViewPageState createState() =>
      _UploadShopFrontViewPageState();
}

class _UploadShopFrontViewPageState extends State<UploadShopFrontViewPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _selfIntroductionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.shopaccount.name;
    _selfIntroductionController.text = widget.shopaccount.shopIntroduction;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _selfIntroductionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('画像が選択されませんでした。');
      }
    });
  }

  Future<String> _uploadImage() async {
    if (_image == null) {
      return widget.shopaccount.logoImage;
    }

    final fileName =
        'images/${widget.shopaccount.id}/${DateTime.now().toIso8601String()}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    final uploadTask = storageRef.putFile(_image!);
    await uploadTask.whenComplete(() => print('画像のアップロード完了'));

    final url = await storageRef.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー情報更新'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // 省略: 既存のプロフィール画像表示と変更ボタン
                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            if (_shopFrontImages[i] != null)
                              Image.file(
                                _shopFrontImages[i]!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            else if (widget.shopaccount.shopFrontImages[i] !=
                                '')
                              Image.network(
                                widget.shopaccount.shopFrontImages[i]!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            else
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey,
                              ),
                            TextButton(
                              onPressed: () => _pickFavoriteImage(i),
                              child: Text('お気に入り画像 ${i + 1} を変更'),
                            ),
                          ],
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                widget.shopaccount.logoImage =
                                    await _uploadImage();

                                // お気に入り画像のアップロード処理
                                for (int i = 0; i < 3; i++) {
                                  _shopFrontImageUploads
                                      .add(_uploadFavoriteImage(i));
                                }
                                List<String> shopFrontImagesUrls =
                                    await Future.wait(_shopFrontImageUploads);
                                widget.shopaccount.shop_front_image_0 =
                                    shopFrontImagesUrls[0];
                                widget.shopaccount.shop_front_image_1 =
                                    shopFrontImagesUrls[1];
                                widget.shopaccount.shop_front_image_2 =
                                    shopFrontImagesUrls[2];

                                bool result = await ShopFirestore.updateShop(
                                    widget.shopaccount);

                                if (result) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pop(context, true);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('エラー'),
                                        content: Text('ユーザー情報の更新に失敗しました。'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('閉じる'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                      child: Text('更新'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  List<File?> _shopFrontImages = [null, null, null, null, null];
  List<Future<String>> _shopFrontImageUploads = [];

  Future<void> _pickFavoriteImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _shopFrontImages[index] = File(pickedFile.path);
      } else {
        print('画像が選択されませんでしたとさ');
      }
    });
  }

  Future<String> _uploadFavoriteImage(int index) async {
    if (_shopFrontImages[index] == null) {
      return widget.shopaccount.shopFrontImages[index] ??
          ''; // 画像が選択されていない場合、元のURLを返す
    }

    final fileName =
        'favorite_images/${widget.shopaccount.id}/${DateTime.now().toIso8601String()}_$index.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    final uploadTask = storageRef.putFile(_shopFrontImages[index]!);
    await uploadTask.whenComplete(() => print('お気に入り画像のアップロード完了'));

    final url = await storageRef.getDownloadURL();
    return url;
  }
}
