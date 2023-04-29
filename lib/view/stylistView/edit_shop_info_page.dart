import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/utils/firestore/shops.dart';

class EditShopInfoPage extends StatefulWidget {
  final Shop shopInfo;

  EditShopInfoPage({required this.shopInfo});

  @override
  _EditShopInfoPageState createState() => _EditShopInfoPageState();
}

class _EditShopInfoPageState extends State<EditShopInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _selfIntroductionController = TextEditingController();
  TextEditingController _hotpepperController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.shopInfo.name;
    _selfIntroductionController.text = widget.shopInfo.shopIntroduction;
    _hotpepperController.text = widget.shopInfo.snsUrl![0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _selfIntroductionController.dispose();
    _hotpepperController.dispose();
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
      return widget.shopInfo.logoImage;
    }

    final fileName =
        'images/${widget.shopInfo.id}/${DateTime.now().toIso8601String()}.jpg';
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ユーザー情報更新',
          style: TextStyle(color: Colors.black),
        ),
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
                    if (_image != null)
                      Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    else
                      widget.shopInfo.logoImage == ""
                          ? Container(
                              child: Text("まだロゴがありません"),
                            )
                          : Image.network(
                              widget.shopInfo.logoImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    TextButton(
                      onPressed: _pickImage,
                      child: Text('ロゴイメージを変更'),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: '名前'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '名前を入力してください';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _selfIntroductionController,
                      decoration: InputDecoration(labelText: '自己紹介'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '自己紹介を入力してください';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _hotpepperController,
                      decoration: InputDecoration(labelText: 'ホットペッパーリンク'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ホットペッパーリンク';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                widget.shopInfo.name = _nameController.text;
                                widget.shopInfo.shopIntroduction =
                                    _selfIntroductionController.text;
                                widget.shopInfo.snsUrl![0] =
                                    _hotpepperController.text;
                                widget.shopInfo.logoImage =
                                    await _uploadImage();
                                bool result = await ShopFirestore.updateShop(
                                    widget.shopInfo);

                                if (result) {
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
                                setState(() {
                                  _isLoading = false;
                                });
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
}
