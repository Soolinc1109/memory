import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/carte.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/view/stylistView/create_stylist_post_page.dart';
import '../../utils/firestore/posts.dart';

class ResisterCustomerPage extends StatefulWidget {
  const ResisterCustomerPage({
    super.key,
  });

  @override
  State<ResisterCustomerPage> createState() => _ResisterCustomerPageState();
}

class _ResisterCustomerPageState extends State<ResisterCustomerPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController katakananameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  final focusNode = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();

  bool onpressed = false;
  bool loading = false; // Add this line to create a new loading variable
  void rebuild() {
    setState(() {});
  }

  int selectedGendernumber = 2;
  Account myAccount = Authentication.myAccount!;

  @override
  Widget build(BuildContext context) {
    handleKeyboardOverlay(context, focusNode);
    handleKeyboardOverlay(context, focusNode2);
    handleKeyboardOverlay(context, focusNode3);
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

          centerTitle: true,

          title: const Text(
            '',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            "顧客登録",
            style: TextStyle(fontSize: 22),
          )),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: TextField(
              focusNode: focusNode,
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
              focusNode: focusNode2,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "カナ名",
              ),
              controller: katakananameController,
            ),
          ),
          Center(
            child: GenderSelection(
              onGenderSelected: (selectedGender) {
                selectedGendernumber = selectedGender;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: TextField(
              focusNode: focusNode3,
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
          Padding(
            padding:
                const EdgeInsets.only(top: 8.0, right: 38, bottom: 8, left: 38),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          if (nameController.text.isNotEmpty &&
                              katakananameController.text.isNotEmpty &&
                              memoController.text.isNotEmpty) {
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
                                gender: selectedGendernumber);

                            final result =
                                await PostFirestore.addCarte(newPost);
                            if (result != null) {
                              setState(() {
                                HapticFeedback.heavyImpact();
                                loading =
                                    false; // Set loading back to false at the end of the onPressed callback
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateStylistPostPage(
                                          carteId: result,
                                        )),
                              );
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
                                        Navigator.of(context)
                                            .pop(); // ダイアログを閉じる
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
                  child: loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('カルテ作成に進む'),
                ),
                ElevatedButton(
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
                                gender: selectedGendernumber);
                            final result =
                                await PostFirestore.addCarte(newPost);
                            if (result != null) {
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
                                        Navigator.of(context)
                                            .pop(); // ダイアログを閉じる
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
                  child: loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('顧客登録'),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class GenderSelection extends StatefulWidget {
  final ValueChanged<int> onGenderSelected;

  GenderSelection({required this.onGenderSelected});

  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  int selectGender = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('性別を選択してください'),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectGender = 0;
                });
                widget.onGenderSelected(selectGender);
              },
              child: Text('男'),
              style: ElevatedButton.styleFrom(
                primary: selectGender == 0 ? AppColors.thirdColor : Colors.grey,
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectGender = 1;
                });
                widget.onGenderSelected(selectGender);
              },
              child: Text('女'),
              style: ElevatedButton.styleFrom(
                primary: selectGender == 1 ? AppColors.thirdColor : Colors.grey,
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectGender = 2;
                });
                widget.onGenderSelected(selectGender);
              },
              child: Text('どちらでもない'),
              style: ElevatedButton.styleFrom(
                primary: selectGender == 2 ? AppColors.thirdColor : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

OverlayEntry createCloseKeyboardButton(
    BuildContext context, FocusNode focusNode) {
  return OverlayEntry(
    builder: (BuildContext context) {
      return Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        right: 0,
        child: Material(
          // この行を追加
          color: Colors.transparent, // この行を追加
          child: IconButton(
            icon: Icon(Icons.keyboard_hide),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              // もしくは
              // focusNode.unfocus();
            },
          ),
        ), // この行を追加
      );
    },
  );
}

void handleKeyboardOverlay(BuildContext context, FocusNode focusNode) {
  final closeButtonOverlay = createCloseKeyboardButton(context, focusNode);

  focusNode.addListener(() {
    if (focusNode.hasFocus) {
      Overlay.of(context)?.insert(closeButtonOverlay);
    } else {
      closeButtonOverlay.remove();
    }
  });
}
