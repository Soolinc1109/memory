import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorys/model/account.dart';
import 'package:memorys/model/shop/shop.dart';
import 'package:memorys/utils/authentication.dart';
import 'package:memorys/utils/color.dart';
import 'package:memorys/utils/firestore/shops.dart';
import 'package:memorys/utils/firestore/users.dart';
import 'package:memorys/view/main_page.dart';
import 'package:memorys/view/startup/signup_clear.dart';

class CreateShopPage extends StatefulWidget {
  const CreateShopPage({Key? key}) : super(key: key);

  @override
  _CreateShopPageState createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController shopnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(children: [
            SizedBox(
              height: 80,
            ),
            Text(
              'お店の情報を登録',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: 310,
                child: Text('お店の名前を入力しお店を作成して下さい（お店の名前ははいつでも変更できます）')),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              child: TextField(
                controller: shopnameController,
                decoration: InputDecoration(
                  hintText: 'お店の名前',
                  filled: true,
                  hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: 300,
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: '電話番号',
                    filled: true,
                    hintStyle: TextStyle(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 280,
              child: ElevatedButton(
                  onPressed: () async {
                    if (shopnameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty) {
                      int phoneNumber = int.parse(phoneController.text);
                      final newShop = Shop(
                        ownerId: myAccount.id,
                        name: shopnameController.text,
                        shopPhone: phoneNumber,
                        shopIntroduction: '',
                        logoImage: '',
                        shop_front_image_0:
                            'https://did2memo.net/wp-content/uploads/2018/10/naver-line-no-image-error.png',
                        shop_front_image_1: '',
                        shop_front_image_2: '',
                        snsUrl: [''],
                        staff: [myAccount.id],
                      );

                      var result = await ShopFirestore.addShopToFirebase(
                          newShop, myAccount);

                      if (result == true) {
                        myAccount.shopId = newShop.id;
                        print(myAccount.shopId);
                        final result1 =
                            await UserFirestore.updateUser(myAccount);
                        if (result1 == true) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.thirdColor,
                  ),
                  child: Text(
                    '次へ',
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
