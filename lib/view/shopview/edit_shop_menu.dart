import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/menu.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/firestore/shops.dart';

class EditShopMenuPage extends StatefulWidget {
  final Menu menu;
  const EditShopMenuPage({super.key, required this.menu});

  @override
  State<EditShopMenuPage> createState() => _EditShopMenuPageState();
}

class _EditShopMenuPageState extends State<EditShopMenuPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  double _sliderValue = 10.0;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.menu.name;
    descriptionController.text = widget.menu.description;
    priceController.text = widget.menu.price.toString();
    _sliderValue = widget.menu.duration.toDouble();
    // _image = widget.menu.menu_image;
  }

  bool onpressed = false;
  bool loading = false; // Add this line to create a new loading variable
  void rebuild() {
    setState(() {});
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
      return widget.menu.menu_image;
    }
    final fileName = 'images/menuimage/${DateTime.now().toIso8601String()}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    final uploadTask = storageRef.putFile(_image!);
    await uploadTask.whenComplete(() => print('画像のアップロード完了'));

    final url = await storageRef.getDownloadURL();
    return url;
  }

  int selectedGendernumber = 2;
  Account myAccount = Authentication.myAccount!;
  File? _image;

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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (_image != null)
          Column(
            children: [
              Center(
                child: Image.file(
                  _image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: _pickImage,
                child: Text('メニューイメージをアップロード'),
              ),
            ],
          )
        else
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  widget.menu.menu_image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                TextButton(
                  onPressed: _pickImage,
                  child: Text('メニューイメージをアップロード'),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "メニュー名",
            ),
            controller: nameController,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "メニュー詳細",
            ),
            controller: descriptionController,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextField(
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: '料金',
              border: OutlineInputBorder(),
            ),
            controller: priceController,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Slider(
                value: _sliderValue,
                min: 10,
                max: 200,
                divisions: 19,
                label: (_sliderValue.round() ~/ 10 * 10).toString(),
                onChanged: (double newValue) {
                  setState(() {
                    _sliderValue = newValue;
                  });
                },
              ),
              Text(
                '施術時間: ${_sliderValue.round()}分',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, right: 38, bottom: 8, left: 38),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        int price = int.parse(priceController.text.toString());
                        int convertedValue = _sliderValue.toInt();
                        if (descriptionController.text.isNotEmpty &&
                            nameController.text.isNotEmpty &&
                            priceController.text.isNotEmpty) {
                          widget.menu.name = nameController.text;
                          widget.menu.price = price;
                          widget.menu.duration = convertedValue;
                          widget.menu.description = descriptionController.text;
                          widget.menu.menu_image = await _uploadImage();
                          final result = await ShopFirestore.updateMenu(
                              myAccount.shopId, widget.menu.id, widget.menu);
                          if (result == true) {
                            setState(() {
                              loading = true;
                            });
                            setState(() {
                              onpressed = true;
                            });
                            setState(() {
                              HapticFeedback.heavyImpact();
                              loading =
                                  false; // Set loading back to false at the end of the onPressed callback
                            });
                            Navigator.pop(context, true);
                            Navigator.of(context).pop();
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
                child: loading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('メニュー登録'),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
