import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'ApiModule/Constant.dart';

class AdvUdata extends StatefulWidget {
  const AdvUdata({super.key});

  @override
  State<AdvUdata> createState() => _AdvUdataState();
}

class _AdvUdataState extends State<AdvUdata> {
  List getAllDAta=[];
  /*Future<void> GetAllDataApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

      // ShowLoadingDialog();
      print('You are Connected');
       Map<String, Object> parameter = new HashMap();


      print(Constant.stdData);
      //  print(json.encode(parameter));
      log(json.encode(parameter));

      http.Response response = await http.get(Uri.parse(Constant.stdData),
        headers: {},
        //body: json.encode(parameter),
      )
          .timeout(const Duration(seconds: 120), onTimeout: () {
        // hideLoadingDialog();
        SetMessage('Unable to reach server, please try again.');
        throw 'Unable to reach server, please try again.';
      }).catchError((error) {
        // hideLoadingDialog();
        throw error;
        //log(error);
      });
      log("${response.statusCode}");
      log("${response.body}");

      // hideLoadingDialog();
      try {
        final Map<String, dynamic> responseData =
        json.decode(response.body.replaceAll('}[]', '}'));
        if (response.statusCode == 200) {
          print("user data");
          setState(() {

          });
        } else {
          setState(() {});
          // SetMessage(responseData['message'].toString());
          // return;
        }
      } on FormatException catch (e) {
        log(e.message);
      }
    }else{
      SetMessage(
          'Internet not available, please check your internet connectivity and try again.');
      return;
    }

  }*/
  Future<void> GetAllDataApi1() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // ShowLoadingDialog();

      Map<String, Object> parameter = new HashMap();


      print(Constant.stdData);
      print(json.encode(parameter));
      //log(json.encode(parameter));

      http.Response response = await http
          .get(
        Uri.parse(Constant.stdData),
        headers: {},
        //body: json.encode(parameter),
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        // hideLoadingDialog();
        SetMessage('Unable to reach server, please try again.');
        throw 'Unable to reach server, please try again.';
      }).catchError((error) {
        // hideLoadingDialog();
        throw error;
        //log(error);
      });
      log("${response.statusCode}");
      log("${response.body}");

      // hideLoadingDialog();
      try {
        getAllDAta=
        json.decode(response.body.replaceAll('}[]', '}'));
        if (response.statusCode == 200) {
        setState(() {

        });
        } else {

          getAllDAta = [];
          setState(() {});
          // SetMessage(responseData['message'].toString());
          return;
        }
      } on FormatException catch (e) {
        log(e.message);
      }
    } else {
      SetMessage(
          'Internet not available, please check your internet connectivity and try again.');
      return;
    }
  }
  Future SetMessage(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetAllDataApi1();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Data 2"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView.builder(
            shrinkWrap: true,
              itemCount: getAllDAta.length,
              itemBuilder: (context,intex){
            return Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("     -: userId ",textDirection: TextDirection.rtl,)),
                      Expanded(flex: 3,child: Text(getAllDAta[intex]["userId"].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("     -: Id",textDirection: TextDirection.rtl,)),
                      Expanded(flex: 3,child: Text(getAllDAta[intex]["id"].toString())),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("     -: Title",textDirection: TextDirection.rtl,)),
                      Expanded(flex: 3,child: Text(getAllDAta[intex]["title"].toString())),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("     -: Body",textDirection: TextDirection.rtl,)),
                      Expanded(flex: 3,child: Text(getAllDAta[intex]["body"].toString())),
                    ],
                  ),

                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
