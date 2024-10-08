import 'dart:convert';
import 'dart:developer';
import 'package:alltype_apidata/ApiModule/preference.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



import 'Constant.dart';

class DemoData_Api {
  bool _isDialogShowing = false;
  Map<String, dynamic> ?parameter_return;

  Future<Map<String, dynamic>?> PostApiData(BuildContext context,Map<String, Object> parameter,String api_url,bool is_loading) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if(is_loading == true){
        _showLoadingDialog(context);
      }

      String token = await PreferenceManager().getPref(Constant.token);

      print('token : ${token}');
      print('URL : ${api_url}');
      print('PARAMETER : ${parameter}');

      try {
        var response = await http.post(
          Uri.parse(api_url.toString()),
          headers: {
            "token": token.toString(),
            "Content-Type": "application/json",
            /*'Authorization': 'Bearer ' + token,
            "authkey": await PreferenceManager().getPref(Constant.token_users_id) + token,
            "appversion": Constant.appversion*/
          },
          body: json.encode(parameter),
          // body: parameter
        ).timeout(Duration(seconds: 120), onTimeout: () {
          if(is_loading == true){
            _hideLoadingDialog(context);
          }
          _setMessage('Unable to reach server, please try agai  n.');
          throw 'Unable to reach server, please try again.';
        });
        if(is_loading == true){
          _hideLoadingDialog(context);
        }
        // print('URL : ${api_url}');
        print("STATUS CODE : ${response.statusCode}");
        log("RESPONSE : ${response.body.toString()}");
        try {
          final Map<String, dynamic> responseBody = json.decode(response.body.replaceAll('}[]', '}'));
          if (response.statusCode == 200) {
            return responseBody;
          }
          else if (response.statusCode == 401) {
            if (responseBody['message'] == "Unauthenticated Request" ||
                responseBody['message'] == "Invalid token.") {
              _showAuthenticationDialog(context);
            }
          } else {
            if (responseBody['response'] == false) {
              _setMessage(responseBody['message'].toString());
            }
          }
        } on FormatException catch (e) {
          print(e.message);
        }
      } on Exception catch (e) {
        if(is_loading == true){
          _hideLoadingDialog(context);
        }
        print('error:: ' + e.toString());
        print('URL : ${api_url}');
      }
      return parameter_return;
    } else {
      _setMessage('Internet not available, please check your internet connectivity and try again.');
      return parameter_return;
    }
  }
  Future<Map<String, dynamic>?> GetApiData(BuildContext context,String api_url,bool is_loading) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if(is_loading == true){
        _showLoadingDialog(context);
      }

      String token = await PreferenceManager().getPref(Constant.token);

      print('URL : ${api_url}');
      //print('PARAMETER : ${parameter}');

      try {
        var response = await http .get(
          Uri.parse(api_url.toString()),
          headers: {
            "token": "token",
            "Content-Type": "application/json",
            /*'Authorization': 'Bearer ' + token,
            "authkey": await PreferenceManager().getPref(Constant.token_users_id) + token,
            "appversion": Constant.appversion*/
          },
          //body: json.encode(parameter),
        ).timeout(Duration(seconds: 120), onTimeout: () {
          if(is_loading == true){
            _hideLoadingDialog(context);
          }
          _setMessage('Unable to reach server, please try again.');
          throw 'Unable to reach server, please try again.';
        });
        if(is_loading == true){
          _hideLoadingDialog(context);
        }

        print("STATUS CODE : ${response.statusCode}");
        print("RESPONSE : ${response.body}");
        try {
          final Map<String, dynamic> responseBody = json.decode(response.body.replaceAll('}[]', '}'));
          if (response.statusCode == 200) {
            return responseBody;
          } else if (response.statusCode == 401) {
            if (responseBody['message'] == "Unauthenticated Request" ||
                responseBody['message'] == "Invalid token." ) {
              _showAuthenticationDialog(context);
            }
          } else {
            if (responseBody['response'] == false) {
              _setMessage(responseBody['message'].toString().toString());
            }
          }
        } on FormatException catch (e) {
          print(e.message);
        }
      } on Exception catch (e) {
        if(is_loading == true){
          _hideLoadingDialog(context);
        }
        print('error:: ' + e.toString());
      }
      return parameter_return;
    } else {
      _setMessage('Internet not available, please check your internet connectivity and try again.');
      return parameter_return;
    }
  }

  Future? _showLoadingDialog(BuildContext context) {
    if (_isDialogShowing == false) {
      _isDialogShowing = true;
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
                        color: Color(0xff5c2511),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Please wait...",
                          style: TextStyle(
                              color: Color(0xff5c2511),
                              fontFamily: 'PPM',
                              fontSize: 15)),
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  void _hideLoadingDialog(BuildContext context) {
    if (_isDialogShowing == true) {
      _isDialogShowing = false;
      Navigator.of(context).pop();
    }
  }

  void setMessage(String msg) => _setMessage(msg);

  static void _setMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static _showAuthenticationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Constant.AuthTitle,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'PPM', fontSize: 15)),
          content: Text(Constant.AuthMsg,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'PPR', fontSize: 13)),
          actions: <Widget>[
            TextButton(
              child: Text("Ok"),
              style: TextButton.styleFrom(
                //  primary: Colors.black,
                  textStyle: TextStyle(
                      color: Colors.black, fontFamily: 'PPM', fontSize: 14)),
              onPressed: () async {
                // Navigator.of(context).pop();
                PreferenceManager().setPref('is_login', '0');
                // PreferenceManager().setPref('securetoken', '');
                // Route route = MaterialPageRoute(builder: (context) => LoginPage());
                // Navigator.push(context, route);
              },
            ),
          ],
        );
      },
    );
  }
}
