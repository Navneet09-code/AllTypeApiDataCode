import 'dart:ui';
import 'package:alltype_apidata/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController txtLogInMobileNo = TextEditingController();
  TextEditingController txtLogInPassword = TextEditingController();
  TextEditingController txtMbNo = TextEditingController();

  bool _passwordVisible = true;
  bool isChecked = false;

  bool checkedValue = false;
  String deviceToken = '';


  void initState() {
    // TODO: implement initState
    super.initState();
    }


  //LogIn Api Data
  void _showSnackbar(String value) {
    final snackBar = SnackBar(
      content: Text("${value.toString()}",style: TextStyle(fontSize: 12),),
      action: SnackBarAction(

        label: 'Undo',backgroundColor: Colors.green,

        onPressed: () {
          // Perform some action when the user taps "Undo".
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  

  Future ShowLoadingDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                margin:
                EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                height: 80,
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 20,
                    ), //show this if state is loading
                    Text("Please wait...",
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'CM',
                            fontSize: 15)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void hideLoadingDialog() {
    Navigator.of(context).pop();
  }
  void _showForgotPassDialog() {
    FocusScope.of(context).unfocus();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.only(left: 25,right: 25),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10.0)),

              child: Container(
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius
                      .circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(
                          0.3),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(
                          0,
                          0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center,
                  crossAxisAlignment: CrossAxisAlignment
                      .start,
                  children: [
                    Padding(
                      padding: const EdgeInsets
                          .only(
                          left: 20,
                          bottom: 5,
                          top: 0,
                          right: 20),
                      child: RichText(
                        textAlign: TextAlign
                            .left,
                        text: TextSpan(
                            text: 'Forgot Password',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors
                                    .black,
                                fontFamily: 'NR'),
                            children: [
                            ]),
                      ),
                    ),
                    Divider(thickness: 0.5,color: Colors.black38,),
                    Container(
                      height: 45,
                      margin: EdgeInsets
                          .only(
                        left: 15,
                        right: 15,
                        top: 18,),
                      padding: EdgeInsets
                          .only(left: 8,
                          right: 8,
                          top: 0),
                      decoration: BoxDecoration(
                          color: Colors
                              .white,
                          borderRadius: BorderRadius
                              .circular(
                              7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black45,
                              spreadRadius: 1,
                              // blurRadius: 2
                            )
                          ]
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: txtMbNo,
                          keyboardType: TextInputType
                              .emailAddress,
                          cursorColor: Color(
                              0xffFF8023),
                          style: TextStyle(
                              color: Colors
                                  .black87,
                              fontFamily: 'PPR',
                              fontSize: 14),
                          decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder
                                  .none,
                              hintText: 'Enter Registered Email ID',
                              hintStyle: TextStyle(
                                  color: Colors
                                      .black26,
                                  fontFamily: 'PPR',
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if (txtMbNo.text.trim().toString() == "") {
                          Text("Please enter valid email id.");
                          return;
                        }
                        // ForgotApi();
                        setState((){});
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 40, bottom: 0, left: 15, right: 15),
                        padding: EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
                        height: 40,
                        decoration: BoxDecoration(color: Colors.green,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.green,)),
                        child: Center(
                            child: RichText(text: TextSpan(text: 'Send Password',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'PPR')),)
                        ),
                      ),
                    )
                  ],

                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'Log ',
                          style: TextStyle(
                              fontSize: 40,
                             fontWeight: FontWeight.bold,
                             // fontFamily: 'SGB',
                              color: Colors.green)),
                      TextSpan(
                        text: 'In',
                        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2, right: 2, top: 40),
                child: TextFormField(
                  controller: txtLogInMobileNo,
                  maxLength: 10,
                 // keyboardType: TextInputType.number,
                 // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      counterText: '',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(Icons.verified_user_rounded),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      hintText: 'User ID',
                      isCollapsed: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.6), width: 2)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.6), width: 0),
                      ),
                      hintStyle: TextStyle(
                          color: Colors.black38,
                          fontFamily: 'PPR',
                          fontSize: 15)),
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin:
                    EdgeInsets.only(left: 2, top: 20, right: 2, bottom: 5),
                    child: TextFormField(
                      controller: txtLogInPassword,
                      obscureText: _passwordVisible,

                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Icon(Icons.password),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          hintText: 'Password',
                          isCollapsed: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.6), width: 0),
                          ),
                          hintStyle: TextStyle(
                              color: Colors.black38,
                              fontFamily: 'PPR',
                              fontSize: 15)),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 0, bottom: 0, left: 5, right: 10),
                        height: MediaQuery.of(context).size.height / 25,
                        width: MediaQuery.of(context).size.width / 16,
                        child: _passwordVisible
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Icon(Icons.lock_open_outlined,color: Colors.blueGrey,)
                        )
                            : Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Icon(Icons.lock_outline,color: Colors.blueGrey,)
                        ),
                      ),
                    ),
                  )
                ],
              ),

              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 0,top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Transform.scale(
                      scale: 1.0,
                      child: Checkbox(
                          side: BorderSide(width: 0.5),
                          //focusColor: Colors.red,
                          // checkColor: Colors.green,
                          activeColor: Colors.green,
                          value: isChecked,
                          onChanged: (val) {
                            setState(() {
                              isChecked = val!;
                              print(val);
                            });
                          }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        margin: EdgeInsets.only(left: 10,top: 20),
                        child: Text(
                          'Remember me',
                          style: TextStyle(
                              fontFamily: 'PPM',
                              color: Colors.black,
                              fontSize: 15),
                        )),
                  )
                ],
              ), //
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: GestureDetector(
                  onTap: () async{
                    if(txtLogInMobileNo.text==""){
                      _showSnackbar("Enter User Id");
                      return;
                    }
                    if (txtLogInMobileNo.text == '') {
                      _showSnackbar("Please Enter Valid User ID");
                      return;

                    }/*if (txtLogInPassword.text == '') {
                      _showSnackbar("Please Enter Valid Password");
                      return;

                    }*/
                    /*if(txtLogInMobileNo.text.length<4){
                      //SnackBar(content: Text('Enter Strong Password'),);
                      _showSnackbar("Enter Strong Password length upto 4");
                      print("data");
                      return;
                    }*/
                    if (txtLogInPassword.text == '') {
                     // SnackBar(content: Text('Please Enter Password'),);
                      _showSnackbar("Please Enter Password");
                      return;
                    }
                     var setRefrence =  await SharedPreferences.getInstance();
                     setRefrence.setBool(MyHomePageState.KeyData, true);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 0, top: 25, bottom: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.brown),
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                        child: Text("Log In",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'SGB'))),
                  ),
                ),
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  */ /*Container(
                      margin: EdgeInsets.only(top: 20,right: 5),
                      // margin: EdgeInsets.only(left: 220,top: 0),
                      child: Text("Have an account already?",style: TextStyle(fontFamily: 'PPR',fontSize: 15,color: Colors.black),)),*/ /*
                  GestureDetector(
                    onTap: (){
                      */ /* Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterMobileNo()));*/ /*
                      // Route route = MaterialPageRoute(builder: (context) => RegisterMobileNo());
                      // Navigator.pushReplacement(context, route);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 15),
                        // margin: EdgeInsets.only(left: 220,top: 0),
                        child: Text("New User?",style: TextStyle(fontFamily: 'SGB',fontSize: 15,color: Colors.blue,decoration: TextDecoration.underline,),)),
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }


}
