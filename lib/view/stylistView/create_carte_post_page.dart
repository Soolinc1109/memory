import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/carte.dart';
import 'package:memorys/utils/authentication.dart';
import '../../utils/firestore/posts.dart';

class CreateCartePostPage extends StatefulWidget {
  const CreateCartePostPage({
    super.key,
  });

  @override
  State<CreateCartePostPage> createState() => _CreateCartePostPageState();
}

class _CreateCartePostPageState extends State<CreateCartePostPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController katakananameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  bool onpressed = false;
  bool loading = false; // Add this line to create a new loading variable
  void rebuild() {
    setState(() {});
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
                        if (nameController.text.isNotEmpty) {
                          setState(() {
                            loading = true;
                          });
                          setState(() {
                            onpressed = true;
                          });

                          final newPost = Carte(
                              post_stylist_account_id: myAccount.id,
                              customer_name: nameController.text,
                              customer_katakana_name:
                                  katakananameController.text,
                              createdAt: (Timestamp.now()),
                              shop_id: myAccount.shopId,
                              customer_id: '',
                              gender: 1);
                          final result = await PostFirestore.addCarte(newPost);
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
                child: loading && nameController.text.isNotEmpty
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('メモる'),
              ),
            )
          ],
          centerTitle: true,

          title: const Text(
            'カルテ作成',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "漢字名",
            ),
            controller: nameController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "カナ名",
            ),
            controller: katakananameController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "性別",
            ),
            controller: genderController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "メモ",
            ),
            controller: memoController,
          ),
        ),
        const SizedBox(
          height: 150,
        ),
      ]),
    );
  }
}
