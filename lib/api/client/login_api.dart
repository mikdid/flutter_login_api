import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login_screen_api/helpers/crypto.dart';
import 'package:login_screen_api/models/user/userModel.dart';


class UrlLogin{

  static String urlBase = 'https://www.mikdid.fr';
  
  static String signIn = urlBase + '/tuto_flutter/login.php';
  

}

class LoginApi{

  static signIn(String? login, String? password) async {

    var result;

    try{

      result = null;

      if(login != null &&  password != null && login != '' &&  password != '') {

        final response = await http.post(Uri.parse(UrlLogin.signIn), body: {"login": encrypt(login), "pwd": encrypt(password)});

        if(response.statusCode == 200 && response.body.length > 0) {

          var data = jsonDecode(decrypt(response.body)); 
          
          if(data != null && data['data'] != null) {
            result = data['data'];
          } 

          //result[0] => message
          //result[1] => success / error
          //result[2] => result
          if(result != null && result[1] != null && result[2] != null && result[1] == 1){ //success
              UserModel.saveUserSession(UserModel.fromJson(result[2]));  // on met user en session
          }
        }
      }
    }catch (e) {
        print('erreur lors login : ' + e.toString());
        result = null ;
    }

    return result;

  }
}