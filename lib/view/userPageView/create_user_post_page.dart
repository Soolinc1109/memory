import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorys/model/account.dart';
import 'dart:math';
import 'package:memorys/model/post.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/function_utils.dart';
import '../../utils/firestore/posts.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({
    super.key,
  });

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  TextEditingController contentController = TextEditingController();
  File? image;
  ImagePicker picker = ImagePicker();
  ImageProvider? imageProvider;

  bool onpressed = false;
  bool loading = false; // Add this line to create a new loading variable
  void rebuild() {
    setState(() {});
  }

  void updateImageProvider() {
    if (image == null) {
      imageProvider = NetworkImage(myAccount.imagepath);
    } else {
      imageProvider = FileImage(image!);
    }
  }

  @override
  void initState() {
    super.initState();
    updateImageProvider();
  }

  Future<String> uploadpostImage(String pid) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(pid).putFile(image!);
    String downloadUrl = await storageInstance.ref(pid).getDownloadURL();
    return downloadUrl;
  }

  Account myAccount = Authentication.myAccount!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          leadingWidth: 95, //leadin
          leading: TextButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: const Color.fromARGB(0, 255, 193, 7),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8),
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        // Check if loading is false before executing the code
                        String generateNonce([int length = 32]) {
                          const charset =
                              '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
                          final random = Random.secure();
                          final randomStr = List.generate(
                                  length,
                                  (_) =>
                                      charset[random.nextInt(charset.length)])
                              .join();
                          return randomStr;
                        }

                        final rondom = generateNonce();
                        if (contentController.text.isNotEmpty &&
                            image != null) {
                          setState(() {
                            loading =
                                true; // Set loading to true at the beginning of the onPressed callback
                          });
                          setState(() {
                            onpressed = true;
                          });
                          String imagePath = '';

                          var _result = await uploadpostImage(rondom);
                          imagePath = _result;

                          final newPost = Post(
                              postAccountId: myAccount.id,
                              content: contentController.text,
                              createdAt: (Timestamp.now()).toDate(),
                              posterImageUrl: myAccount.imagepath,
                              postImageUrl: imagePath,
                              posterId: 'posterId');
                          final result = await PostFirestore.addPost(newPost);
                          if (result == true) {
                            setState(() {
                              HapticFeedback.heavyImpact();
                              loading =
                                  false; // Set loading back to false at the end of the onPressed callback
                            });
                            Navigator.pop(context, true);
                          }
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: false, // ダイアログ外をタップしても閉じない
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('テキスト、画像を埋めて下さい'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // ダイアログを閉じる
                                    },
                                    child: Text('埋める'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        setState(() {
                          HapticFeedback.heavyImpact();
                        });
                        setState(() {
                          onpressed = false;
                        });
                      },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(35),
                  ),
                )),
                child: loading && contentController.text.isNotEmpty
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Tweet'), // Show 'Tweet' text when not loading
              ),
            )
          ],
          centerTitle: true,

          title: const Text(
            '新規投稿',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            radius: 22,
            foregroundImage: NetworkImage(myAccount.imagepath),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "いまどうしてる？",
            ),
            controller: contentController,
          ),
        ),
        const SizedBox(
          height: 150,
        ),
        InkWell(
          onTap: () async {
            var result = await FunctionUtils.getImageFromGallery();
            if (result != null) {
              setState(() {
                image = File(result.path);
              });
            }
          },
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: image == null
                  ? const CircleAvatar(child: Icon(Icons.photo))
                  : Image.file(
                      image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )),
        )
      ]),
    );
  }
}
