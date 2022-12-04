import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils {
  static Future<dynamic> getImageFromGalery() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<String> uploadImage(String uid, File image) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image);
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadPostImage(String uid, File image) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image);
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    return downloadUrl;
  }

  static Future<Map<String,String>> addPostImage(String uid, File image) async {
    Map<String,String> result = {};
    String randomString = generateRandomString();
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child('$uid/$randomString').putFile(image);
    String downloadUrl =
        await storageInstance.ref('$uid/$randomString').getDownloadURL();
    result['downloadUrl']= downloadUrl; 
    result['randomString']= randomString; 
    
    return result;
  }

  static String generateRandomString([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    final Random random = Random.secure();
    final String randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    return randomStr;
  }
}
