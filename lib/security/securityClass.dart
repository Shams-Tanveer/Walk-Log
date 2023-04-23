import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:walk_log/component/snackBar.dart';
import 'package:walk_log/controller/userController.dart';
import 'package:walk_log/model/userModel.dart';
import 'package:walk_log/pages/homepage.dart';
import 'package:walk_log/pages/walkingType.dart';

class SecurityClass {
  static final storage = new FlutterSecureStorage();
  static Future<bool> isUserNew() async {
    String? value = await storage.read(key: "deviceId");
    if (value != null) {
      print(value);
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getUserId()async{
    String? value = await storage.read(key: "deviceId");
    String? value1 = await storage.read(key: "secretKey");
    return encrypt(value!, value1!);
  }

  static Future<double> getStrideLength() async{
    String? value = await storage.read(key: "strideLength");
    return double.parse(value!);
  }

  static assignUser(double height,double weight,String gender){
    
    String deviceId = Uuid().v4();
    String secretKey = Uuid().v1();
    String encrypted = encrypt(deviceId, secretKey);

    final user = User(
            uniqueId: encrypted,
            height: height,
            weight: weight,
            gender: gender)
        .toJson();
    double strideLength =  height * (gender=="Male"?0.415:0.413);
    FirebaseFirestore.instance.collection("users").add(user).then((value) {
      user["id"] = value.id;
      value.set(user).then((value) async {
        await storage.write(key: "deviceId", value: deviceId);
        await storage.write(key: "secretKey", value: secretKey);
        await storage.write(key: "strideLength", value: strideLength.toString());
        Get.to(WalkingTypePage());
      }).catchError((error)=>SnackBarUtility.showSnackBar(error.toString()));
    }).catchError((error)=>SnackBarUtility.showSnackBar(error.toString()));
  }

  static String encrypt(String plaintext, String key) {
    final keyBytes = Uint8List.fromList(utf8.encode(key.replaceAll("-", "")));
    final plaintextBytes = utf8.encode(plaintext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String ciphertext, String key) {
    final keyBytes = Uint8List.fromList(utf8.encode(key.replaceAll("-", "")));
    final encryptedBytes = base64.decode(ciphertext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.cbc));
    final decryptedText = encrypter.decrypt(Encrypted(encryptedBytes), iv: iv);
    return decryptedText;
  }
}
