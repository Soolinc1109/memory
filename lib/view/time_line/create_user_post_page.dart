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

  bool onpressed = false;
  void rebuild() {
    setState(() {});
  }

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
                onPressed: onpressed == true
                    ? null
                    : () async {
                        setState(() {
                          onpressed = true;
                        });
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

                        if (contentController.text.isNotEmpty) {
                          String imagePath = '';
                          if (image == null) {
                            imagePath = "";
                          } else {
                            var result = await uploadpostImage(rondom);
                            imagePath = result;
                          }
                          Post newPost = Post(
                              postAccountId: myAccount.id,
                              content: contentController.text,
                              createdAt: Timestamp.now(),
                              posterImageUrl: myAccount.imagepath,
                              postImageUrl: imagePath,
                              posterId: 'posterId');
                          final result = await PostFirestore.addPost(newPost);
                          if (result == true) {
                            Navigator.of(context).pop();
                          }
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
                child: const Text('Tweet'),
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
                : Image(
                    image: imageProvider!,
                  ),
          ),
        )
      ]),
    );
  }
}
