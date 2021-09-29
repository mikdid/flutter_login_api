import 'package:flutter/material.dart';

class CustomStringParam{

  // login screen
  static String loginScreenAppBarText = 'Welcome';
  static String loginScreenTitle = 'login'.toUpperCase();
  static String loginScreenLabelLogin = 'Username';
  static String loginScreenLabelPwd = 'Password';
  static String loginScreenTextForgotPwd = "Forgot your password ?";
  static String loginScreenBtnSbmitText = 'sign in'.toUpperCase();
  static String loginScreenTextNotAccount = "Don't have a account ? sign up ";
  static String loginScreenPathBottomImage = 'assets/images/bottom_blue.png' ;

  //register screen
  static String registerScreenAppBarText = 'Back';
  static String registerScreenTitle = 'register'.toUpperCase();
  static String registerScreenLabelLogin = 'Username';
  static String registerScreenLabelEmail = 'Email';
  static String registerScreenLabelPwd = 'Password';
  static String registerScreenLabelPwdConfirm = 'Password confirm';
  static String registerScreenBtnSbmitText = 'sign up'.toUpperCase();
  static String registerScreenTextAlreadyAccount = "Already have a account ? sign in ";
  static String registerScreenPathBottomImage = 'assets/images/bottom_blue.png' ;

}

class CustomUrlParam{

    //appel sur mikdid php
    //static String urlApiLoginBase = 'https://www.mikdid.fr';
    //static String urlApiLoginSignin = '/tuto_flutter/login.php';

    static String urlApiLoginBase = 'http://127.0.0.1:8899';
    static String urlApiLoginSignin = '/flu/login_screen/signin';

}


extension CustomColorScheme on ColorScheme {
  
  /* -- ! Change param here ! -- */

  //login screen
  static Color loginLightAccent = Colors.blue.shade300;
  static Color loginDarkAccent = Color(0x2228a745);

  // alert
  static Color alertDarkMode = Color(0x2228a745);
  static Color alertSuccess = Color(0xFF28a745);
  static Color alertInfo = Color(0xFF17a2b8);
  static Color alertWarning = Color(0xFFffc107);
  static Color alertError = Color(0xFFdc3545);


  

  /* -- ! Don't touch here ! -- */

  // theme light / dark

  //login screen
  Color get loginScreenAppBar =>
      brightness == Brightness.light ? loginLightAccent : loginDarkAccent;
  Color get loginScreenTtitre =>
      brightness == Brightness.light ? loginLightAccent : loginDarkAccent;
  Color get loginScreenBtnSubmit =>
      brightness == Brightness.light ? loginLightAccent : loginDarkAccent;
  Color get loginScreenLink =>
      brightness == Brightness.light ? loginLightAccent : loginDarkAccent;
  

  // alert
  Color get success =>
      brightness == Brightness.light ? alertSuccess : alertDarkMode;
  Color get info =>
      brightness == Brightness.light ? alertInfo : alertDarkMode;
  Color get warning =>
      brightness == Brightness.light ? alertWarning : alertDarkMode;
  Color get danger =>
      brightness == Brightness.light ? alertError : alertDarkMode;
}
