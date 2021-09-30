import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_screen_api/helpers/crypto.dart';
import 'package:login_screen_api/screens/login/login.dart';
import 'package:login_screen_api/config/config.dart';
import 'package:http/http.dart' as http;


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _key = GlobalKey<FormState>();
  bool _loading = false;

  bool logged = false;

  String errorMessage = "";
  String successMessage = "";
  

  void registerUser(String _login, String _pwd, String _email, String _tel) async {

    setState(() {
      errorMessage = ''; 
      successMessage = '';
      _loading = true; // on affiche loader
    });

    final response = await http.post(
                      Uri.parse(CustomUrlParam.urlApiLoginBase + CustomUrlParam.urlApiLoginRegisterUser), 
                      body: {"login": encrypt(_login), "password": encrypt(_pwd),"email": encrypt(_email),"tel": encrypt(_tel) }
                    );

    if(response.statusCode == 200){

      var result;
      var data = jsonDecode(decrypt(response.body));

      if(data != null && data['data'] != null) {
        result = data['data'];
      } else {
        result = null;
      }

    }

  }



  final TextEditingController txtLogin = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtPasswordConfirm = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;



    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(CustomStringParam.registerScreenAppBarText),
          backgroundColor: Theme.of(context)
              .colorScheme
              .loginScreenAppBar, // Colors.indigo.shade100,
          elevation: 0.0,
          titleSpacing: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen())), // on retourn à la vue correspondant à l'index 2,
          ),
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
          width: double.infinity,
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
                child: Form(
                  key: _key,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(minWidth: 200, maxWidth: 600),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical:20.0),
                          child: Text(
                            CustomStringParam.registerScreenTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .loginScreenTtitre,
                                fontSize: 32),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 40.0, vertical:0.0),
                          child: TextField(
                            controller: txtLogin,
                            decoration: InputDecoration(
                              labelText: CustomStringParam.registerScreenLabelLogin,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: txtEmail,
                            decoration: InputDecoration(
                              labelText: CustomStringParam.registerScreenLabelEmail,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: txtPassword,
                            decoration: InputDecoration(
                              labelText: CustomStringParam.registerScreenLabelPwd,
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          child: TextField(
                            controller: txtPasswordConfirm,
                            decoration: InputDecoration(
                              labelText: CustomStringParam.registerScreenLabelPwdConfirm,
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if(_key.currentState!.validate()){
                                registerUser(txtLogin.text, txtPassword.text, txtEmail.text, '0606060606');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context)
                                  .colorScheme
                                  .loginScreenBtnSubmit,
                              side: BorderSide(color: Colors.grey, width: 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: size.width * 0.5,
                              //padding:EdgeInsets.all(0),
                              child: Text(
                                CustomStringParam.registerScreenBtnSbmitText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        width: size.width,
                        alignment:Alignment.center ,
                        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen())),
                          },
                          child: Text(CustomStringParam.registerScreenTextAlreadyAccount,
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
