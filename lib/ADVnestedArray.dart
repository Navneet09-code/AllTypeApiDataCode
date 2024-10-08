import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;

import 'ApiModule/Constant.dart';

class AdvNestedArray extends StatefulWidget {
  const AdvNestedArray({super.key});

  @override
  State<AdvNestedArray> createState() => _AdvNestedArrayState();
}

class _AdvNestedArrayState extends State<AdvNestedArray> {
  String _status ='';
  String _message ='';
  List<dynamic> _empDataList=[];
  Future<void> empDataApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

      // ShowLoadingDialog();
      print('You are Connected');
      // Map<String, Object> parameter = new HashMap();


      print(Constant.empData);
      //  print(json.encode(parameter));
      //log(json.encode(parameter));

      http.Response response = await http.get(Uri.parse(Constant.empData),
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
          print("Successful");
          _status = responseData['status'];
          _empDataList = responseData['data'];
          _message = responseData['message'];
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
    empDataApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ADV Nested Array"),centerTitle: true,),
      body: Container(
        child: Column(
          children: [
            Text("Status :- ${_status.toString()}"),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26)
              ),
              height: MediaQuery.of(context).size.height/1.3,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: _empDataList.length,
                    itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Emplyee ID  :-  ",style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                  child: Text("${_empDataList[index]["id"].toString()}",style: TextStyle(fontSize: 12),)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                 // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Emplyee Name  :-  ",style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text("${_empDataList[index]["employee_name"].toString()}",style: TextStyle(fontSize: 12),)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Emplyee Salary  :-  ",style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text("${_empDataList[index]["employee_salary"].toString()}",style: TextStyle(fontSize: 12),)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Emplyee Age  :-  ",style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text("${_empDataList[index]["employee_age"].toString()}",style: TextStyle(fontSize: 12),)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Emplyee Image  :-  ",style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text("${_empDataList[index]["profile_image"]!=''?_empDataList[index]["profile_image"].toString():"No Image Found"}",style: TextStyle(fontSize: 12),)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text("Message :- ${_message.toString()}")
          ],
        ),
      ),
    );
  }
}

