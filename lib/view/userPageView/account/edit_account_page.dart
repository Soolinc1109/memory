import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/utils/firestore/users.dart';

class UserUpdatePage extends StatefulWidget {
  final Account account;

  UserUpdatePage({required this.account});

  @override
  _UserUpdatePageState createState() => _UserUpdatePageState();
}

class _UserUpdatePageState extends State<UserUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _selfIntroductionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.account.name;
    _selfIntroductionController.text = widget.account.selfIntroduction;
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
      return widget.account.imagepath;
    }

    final fileName =
        'images/${widget.account.id}/${DateTime.now().toIso8601String()}.jpg';
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
                    if (_image != null)
                      Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    else
                      Image.network(
                        widget.account.imagepath,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    TextButton(
                      onPressed: _pickImage,
                      child: Text('写真を変更'),
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
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                widget.account.name = _nameController.text;
                                widget.account.selfIntroduction =
                                    _selfIntroductionController.text;
                                widget.account.imagepath = await _uploadImage();
                                bool result = await UserFirestore.updateUser(
                                    widget.account);

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
