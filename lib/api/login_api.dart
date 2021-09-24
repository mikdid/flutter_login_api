import 'dart:convert';

import 'package:http/http.dart' as http;


class UrlLogin{

  static String urlBase = 'https://www.mikdid.fr';
  
  static String signIn = urlBase + '/tuto_flutter/login.php';
  

}

class LoginApi{

  static signIn(String login, String password) async {

    try{

        final response = await http.post(Uri.parse(UrlLogin.signIn), body: {"login": login, "pwd": password});

        if(response.statusCode == 200 && response.body.length > 0) {
          
          var result;

          var data = jsonDecode(response.body); //jsonDecode(decrypt(response.body));
          
          if(data != null && data['data'] != null) {
            result = data['data'];
          } else {
            result = null;
          }

          if(result != null && result[1] != null && result[2] != null && result[1] == 1){ //success
            // TODO => UserModel.saveUserSession(UserModel.fromJson(result[2]));  //info user sont result[2] => on le met en session
          }



        }
        else { return null; }
     }catch (e) {
        print('erreur lors publication post : ' + e.toString());
        return null ;
    }

  }
}