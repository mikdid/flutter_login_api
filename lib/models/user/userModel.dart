
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  
  String? _id;
  String? login;
  String? password;
  String? email;
  String? tel;

  static UserModel? sessionUser;

  UserModel(this._id,this.login,this.password,this.email,this.tel);

  // factory est un constructeur qui peut retourner l'instance courante plutot qu'en créer une nouvelle
  // => prend en entree Map <clé, valeur> et return l'objet de l'instance en cours
  // note : Map dynamic car on peut retourné données de type String, int, float
  factory UserModel.fromJson(Map<String, dynamic> i) =>
      UserModel(i['_id'], i['login'], i['password'],  i['email'],  i['tel']);

  //pour transformer instance d'objet en map (en fait inverse du constructeur ci-dessus)
  Map<String, dynamic> toMap() => { "id": this._id, "login": login, "password": password, "email": email, "tel": tel };

  // fonction qui va sauvegarder la session de l'utilisateur
  static saveUserSession(UserModel user) async {
  
    SharedPreferences pref = await SharedPreferences.getInstance(); //SharedPreferences ne sauvegarde que les string et les int

    //on doit convertir user en string pour pouvoir etre sotckée via SharedPreferences
    var data = json.encode(user.toMap());
    pref.setString("userlogged", data);

  }

  // fonction qui va chercher la session de l'utilisateur
  static getUserSession() async {
    
    SharedPreferences pref = await SharedPreferences.getInstance();

    var data = pref.getString("userlogged");

    if(data != null){
      var decode = json.decode(data); 
      var user = UserModel.fromJson(decode);
      sessionUser = user;
    } else {
      sessionUser = null;
    }
  }

  static void logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("userlogged");
    sessionUser = null;
  }

}