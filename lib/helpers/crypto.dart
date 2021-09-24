
import 'package:encrypt/encrypt.dart';

final key = Key.fromUtf8("je-suis-une-cle-de-32-caracteres"); //  CLE : 32 CARACTERES OBLIGATOIREMENT
final vecteurIV = IV.fromUtf8("et-moi-une-de-16"); // vecteur d'identification : 16 CARACTERES OBLIGATOIREMENT 

String encrypt(String text){
  final encrypter =  Encrypter(AES(key,mode: AESMode.cbc));
  final messageCrypter = encrypter.encrypt(text, iv: vecteurIV);
  return messageCrypter.base64;
}

String decrypt(String text) {
  final encrypter = Encrypter(AES(key,mode: AESMode.cbc));
  final messageDecrypter = encrypter.decrypt(Encrypted.fromBase64(text), iv: vecteurIV);
  return messageDecrypter;
}