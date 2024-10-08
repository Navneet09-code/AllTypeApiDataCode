import 'dart:async';


import 'package:alltype_apidata/HomePage.dart';
import 'package:alltype_apidata/LoginPage.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: "",),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const String KeyData ="isLoggedIn";
  void _checkLoginAuth() async{
    var sharedPrefrence =  await SharedPreferences.getInstance();
    var _isLogin = sharedPrefrence.getBool(KeyData);
    Timer(
        Duration(seconds: 3),
            () {

              if(_isLogin!=null){
                if(_isLogin){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
                  setState(() {

                  });
                }else{
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => LogInPage()));
                  setState(() {

                  });
                }

              }else{
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => LogInPage()));
                setState(() {

                });
              }

            }

    );
  }
  @override
  void initState() {
    super.initState();
    // Ensure that the context is available when the Timer fires
    _checkLoginAuth();
  }

  @override
  Widget build(BuildContext context) {
   /* Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LogInPage())));*/
    return Scaffold(

      body: Container(
          decoration: BoxDecoration(image: DecorationImage(image:  AssetImage('assets/flashScreen.jpeg'),fit: BoxFit.fill,),
          )),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
