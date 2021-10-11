import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_screen_api/helpers/alertHelper.dart';
import 'package:login_screen_api/helpers/crypto.dart';
import 'package:login_screen_api/models/user/userModel.dart';
import 'package:login_screen_api/screens/home/home.dart';
import 'package:login_screen_api/screens/login/register.dart';
import 'package:login_screen_api/config/config.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  
  final _key = GlobalKey<FormState>(); //pour formulaire
  bool _loading = false;  
  bool logged = false;
  bool loginOk = false;
  String resultMessage = "";
  String resultTitre = ""; 


  // fonction pour appel http api login
  signIn(String _login, String _pwd) async {

    try{
      
      setState(() {
        resultTitre = '';
        resultMessage = '';
        _loading = true; // show loader
      });

      final response = await http.post(
                        Uri.parse(CustomUrlParam.urlApiLoginBase + CustomUrlParam.urlApiLoginSignin), 
                        body: {"login": encrypt(_login), "password": encrypt(_pwd)}
                      );
      
      if(response.statusCode == 200){

        var body = jsonDecode(response.body);
        var user;

        if(body != null && body['statut'] == 'success' && body['data'] != null){
          
          user = jsonDecode(decrypt(body['data']));

          if(user != null && user['_id'] != ''){
            setState(() {
              resultTitre = 'Success';
              resultMessage = 'User logged with success';
              _loading = false;
              loginOk = true;
            });

            UserModel.saveUserSession(UserModel.fromJson(user));  //save user to session
          }
        }

        if(loginOk != true){
          setState(() {
            resultTitre = 'Erreur';
            resultMessage = 'Error created user';
            _loading = false;
          });
        }   
      } else{
        setState(() {
          resultTitre = 'Error';
          resultMessage = 'Error login user';
          _loading = false;
          loginOk = true;
        });
      } 
    }catch(error){
      setState(() {
          resultTitre = 'Error';
          resultMessage = 'Error login process';
          _loading = false;
          loginOk = true;
      });
    }
  }

  void saveUserSession(){

  }

  final TextEditingController txtLogin = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child:Scaffold(
        appBar: AppBar(
          title: Text(CustomStringParam.loginScreenAppBarText),
          backgroundColor: Theme.of(context).colorScheme.loginScreenAppBar, // Colors.indigo.shade100,
          elevation: 0.0,
          titleSpacing: 20.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.more_vert
                ),
              )
            ),
          ],
        ),
        
        body: Container(
          width: size.width, //double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned( 
                bottom: 0,
                left: 0,
                right:0,
                height: 150,
                child:FittedBox(
                    child: Image.asset(CustomStringParam.loginScreenPathBottomImage),
                    fit: BoxFit.fill,
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child:Form(
                  key: _key,
                  child:  Center(
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      Container(
                        constraints: BoxConstraints(minWidth: 200, maxWidth: 600),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          CustomStringParam.loginScreenTitle,
                          style: TextStyle(
                            fontWeight:FontWeight.bold,
                            color: Theme.of(context).colorScheme.loginScreenTtitre,  
                            fontSize: 32
                            ),
                            textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                        alignment: Alignment.center,
                        margin:EdgeInsets.symmetric(horizontal: 40.0),
                        child:TextField(
                          controller: txtLogin,
                          decoration:InputDecoration(
                            labelText: CustomStringParam.loginScreenLabelLogin,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                        alignment: Alignment.center,
                        margin:EdgeInsets.symmetric(horizontal: 40.0),
                        child:TextField(
                          controller: txtPassword,
                          decoration:InputDecoration(
                            labelText: CustomStringParam.loginScreenLabelPwd,
                          ),
                          obscureText: true,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                        alignment: Alignment.centerRight,
                        margin:EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                        child:Text(
                          CustomStringParam.loginScreenTextForgotPwd,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.loginScreenLink,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                        alignment: Alignment.center,
                        margin:EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child:ElevatedButton( 
                            onPressed: () async {
                            if(_key.currentState!.validate()){
                              await signIn(txtLogin.text, txtPassword.text);
                              await showSimpleAlert(context,resultTitre,resultMessage); // wait click ok btn

                              if(loginOk == true){
                                saveUserSession();

                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>HomeScreen())); // go to login page
                                  
                              }
                            }
                          },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.loginScreenBtnSubmit, 
                              side: BorderSide(color: Colors.grey, width: 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: size.width * 0.5,
                            //padding:EdgeInsets.all(0),
                            child: Text(
                              CustomStringParam.loginScreenBtnSbmitText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ), 
                          ),
                        ),
                      ),
                      /*SizedBox(
                        height: size.height * 0.03,
                      ),*/
                      Container(
                        width: size.width,
                        alignment:Alignment.center ,
                        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterScreen())),
                          },
                          child: Text(CustomStringParam.loginScreenTextNotAccount,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color : Theme.of(context).colorScheme.loginScreenLink,
                            decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                    ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

















/*

    return Scaffold(

      body:Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            

            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight:FontWeight.bold,
                  color: Colors.indigo.shade200, // Color(0xFF2661FA) ,
                  fontSize: 36
                  ),
                  textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Container(
              alignment: Alignment.center,
              margin:EdgeInsets.symmetric(horizontal: 40.0),
              child:TextField(
                decoration:InputDecoration(
                  labelText: "Username",
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              alignment: Alignment.center,
              margin:EdgeInsets.symmetric(horizontal: 40.0),
              child:TextField(
                decoration:InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin:EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child:Text(
                "Forgot your password ?",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0XFF2661FA)
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),

          ],
          ),
      ),
    );
  }
}*/