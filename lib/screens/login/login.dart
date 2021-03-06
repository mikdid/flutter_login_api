import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_api/class/menuItemChoice.dart';
import 'package:login_screen_api/helpers/alertHelper.dart';
import 'package:login_screen_api/helpers/crypto.dart';
import 'package:login_screen_api/models/user/userModel.dart';
import 'package:login_screen_api/screens/home/home.dart';
import 'package:login_screen_api/screens/login/register.dart';
import 'package:login_screen_api/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen_api/widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSecret = true; // pour password
  final _key = GlobalKey<FormState>(); //pour formulaire
  bool _loading = false;
  //bool logged = false;
  bool loginOk = false;
  String resultMessage = "";
  String resultTitre = "";

  // signi user => redirect homeScreen if ok
  signIn(String _login, String _pwd) async {
    try {
      setState(() {
        resultTitre = '';
        resultMessage = '';
        _loading = true; // show loader
      });

      final response = await http.post(
          Uri.parse(CustomUrlParam.urlApiLoginBase +
              CustomUrlParam.urlApiLoginSignin),
          body: {"login": encrypt(_login), "password": encrypt(_pwd)});

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        var user;

        if (body != null &&
            body['statut'] == 'success' &&
            body['data'] != null) {
          user = jsonDecode(decrypt(body['data']));

          if (user != null && user['_id'] != '') {
            setState(() {
              resultTitre = 'Success';
              resultMessage = 'User logged with success';
              _loading = false;
              loginOk = true;
            });

            await UserModel.saveUserSession(
                UserModel.fromJson(user)); //save user to session
          }
        }

        if (loginOk != true) {
          setState(() {
            resultTitre = 'Erreur';
            resultMessage = 'Error created user';
            _loading = false;
          });
        }
      } else {
        setState(() {
          resultTitre = 'Error';
          resultMessage = 'Error login user';
          _loading = false;
          loginOk = false;
        });
      }
    } catch (error) {
      setState(() {
        resultTitre = 'Error';
        resultMessage = 'Error login process';
        _loading = false;
        loginOk = false;
      });
    }
  }

  //*********** menu appBarr ***************

  final List<MenuItemChoice> appBarMenuItemList = const <MenuItemChoice>[
    const MenuItemChoice(title: 'Settings', icon: Icons.settings),
    const MenuItemChoice(title: 'Help', icon: Icons.help),
  ];

  //click sur le menu dans l'appBarr
  void handleAppBarMenuClicked(BuildContext context, MenuItemChoice value) {
    switch (value.title) {
      case 'Help':
        print('Help');
        //Navigator.push() ...
        break;
      case 'Settings':
        print('Settings');
        break;
    }
  }

  //******** end menu appbar */

  final TextEditingController txtLogin = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // si _loading = true on return wait sinon on retur le SafeArea
    return _loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(CustomStringParam.loginScreenAppBarText),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .loginScreenAppBar, // Colors.indigo.shade100,
                elevation: 0.0,
                titleSpacing: 20.0,
                actions: <Widget>[
                  PopupMenuButton<MenuItemChoice>(
                    onSelected: (val) => handleAppBarMenuClicked(context, val),
                    itemBuilder: (BuildContext context) {
                      return appBarMenuItemList.map((MenuItemChoice itemMenu) {
                        return PopupMenuItem<MenuItemChoice>(
                          value: itemMenu,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                itemMenu.icon,
                              ),
                              Container(
                                width: 10.0,
                              ),
                              Text(
                                itemMenu.title,
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
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
                      right: 0,
                      height: 150,
                      child: FittedBox(
                        child: Image.asset(
                            CustomStringParam.loginScreenPathBottomImage),
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
                                constraints: BoxConstraints(
                                    minWidth: 200, maxWidth: 600),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 40.0),
                                child: Text(
                                  CustomStringParam.loginScreenTitle,
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
                                height: size.height * 0.04,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    minWidth: 100, maxWidth: 500),
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 40.0),
                                child: TextFormField(
                                  controller: txtLogin,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'login is required'
                                          : null,
                                  decoration: InputDecoration(
                                    labelText:
                                        CustomStringParam.loginScreenLabelLogin,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    minWidth: 100, maxWidth: 500),
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 40.0),
                                child: TextFormField(
                                  controller: txtPassword,
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'password is required'
                                          : null,
                                  decoration: InputDecoration(
                                    labelText:
                                        CustomStringParam.loginScreenLabelPwd,
                                    suffixIcon: InkWell(
                                      onTap: () => {
                                        setState(
                                            () => {_isSecret = !_isSecret}),
                                      },
                                      child: Icon(
                                        !_isSecret
                                            ? Icons.visibility
                                            : Icons
                                                .visibility_off, //oeil password
                                      ),
                                    ),
                                  ),
                                  obscureText: _isSecret,
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    minWidth: 100, maxWidth: 500),
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 10.0),
                                child: Text(
                                  CustomStringParam.loginScreenTextForgotPwd,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .loginScreenLink,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    minWidth: 100, maxWidth: 500),
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_key.currentState!.validate()) {
                                      await signIn(
                                          txtLogin.text, txtPassword.text);
                                      await showSimpleAlert(
                                          context,
                                          resultTitre,
                                          resultMessage); // wait click ok btn

                                      if (loginOk == true) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen())); // go to login page
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context)
                                        .colorScheme
                                        .loginScreenBtnSubmit,
                                    side: BorderSide(
                                        color: Colors.grey, width: 1),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
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
                              Container(
                                width: size.width,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 50, 
                                  vertical: 20
                                ),
                                child: GestureDetector(
                                  onTap: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen())),
                                  },
                                  child: Text(
                                    CustomStringParam.loginScreenTextNotAccount,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .loginScreenLink,
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
