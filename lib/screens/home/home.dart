import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_api/config/config.dart';
import 'package:login_screen_api/models/user/userModel.dart';
import 'package:login_screen_api/screens/login/login.dart';

  class HomeScreen extends StatefulWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool logged = false;

  isLogged() async {

    await UserModel.getUserSession();

    if(UserModel.sessionUser == null){
      setState(() {
        logged = false;
      });
    } else {
      setState(() {
        logged = true;
      });
    } 
  }

  logout(BuildContext context){
    UserModel.logOut();
    isLogged();
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) =>LoginScreen())
    ); // go to login page   
  }

  @override
  void initState() {
    super.initState();
    isLogged();

    
  }


  @override
  Widget build(BuildContext context) {

    return logged != true ? LoginScreen() :
      Scaffold(
          appBar: AppBar(
            title: Text(CustomStringParam.homeScreenAppBarText),
            backgroundColor: Theme.of(context).colorScheme.homeScreenAppBar, // Colors.indigo.shade100,
            elevation: 0.0,
            titleSpacing: 20.0,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    logout(context);
                  },
                  child: Icon(
                      Icons.exit_to_app
                  ),
                )
              ),
            ],
          ),
      body: Center(
          child: Column (
              children: [
                ElevatedButton(child: Text("Logout"), onPressed:(){

                  logout(context);

                }),
                Icon(Icons.ac_unit, size: 48, color: Colors.blue),
                /*ElevatedButton(
                    child: Text("Button 2"),
                    onPressed:(){},
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size.square(70))
                    )
                ),
                ElevatedButton(child: Text("Very Long Button 3"), onPressed:(){}),*/
              ]
          )
      ),
    );
  }

}