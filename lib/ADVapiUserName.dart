import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'ApiModule/Constant.dart';
class AdvUserDataApiPage extends StatefulWidget {
  const AdvUserDataApiPage({super.key});

  @override
  State<AdvUserDataApiPage> createState() => _AdvUserDataApiPageState();
}

class _AdvUserDataApiPageState extends State<AdvUserDataApiPage> {
  List<dynamic> getAllDAta=[];
   String page="";
   String per_page="";
   String total="";
   String total_pages="";

  Future<void> _getUserData()async{
    var checkResult =await (Connectivity().checkConnectivity());
    if(checkResult==ConnectivityResult.mobile || checkResult == ConnectivityResult.wifi){
      print("you are online");
    }else{
      print("No data");
    }
  }
  Future<void> GetAllDataApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

      // ShowLoadingDialog();
      print('You are Connected');
     // Map<String, Object> parameter = new HashMap();


      print(Constant.DemoData);
    //  print(json.encode(parameter));
      //log(json.encode(parameter));

      http.Response response = await http.get(Uri.parse(Constant.DemoData),
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
          page = responseData["page"].toString();
          per_page = responseData["per_page"].toString();
          total_pages = responseData["total_pages"].toString();
          total = responseData["total"].toString();

          getAllDAta = responseData['data'];
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
   GetAllDataApi();
   // _getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Data "),centerTitle: true,),
      body: Column(
        children: [
          Text(" Page :- ${page.toString()}"),
          Text(" Per Page :- ${per_page.toString()}"),
          Text(" Total :- ${total.toString()}"),
          Text(" Total Page :- ${total_pages.toString()}"),
          Container(
            height: MediaQuery.of(context).size.height/2,
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: getAllDAta.length,
                itemBuilder: (context,index){
                String hexColor = getAllDAta[index]['color'].toString();
              return Container(
                child: Column(
                  children: [
                    Text(" Id :- ${getAllDAta[index]['id'].toString()}"),
                    Text(" Name :- ${getAllDAta[index]['name'].toString()}"),
                    Text(" Year :- ${getAllDAta[index]['year'].toString()}"),
                    Text(" Phantom Value :- ${getAllDAta[index]['pantone_value'].toString()}"),
                    Container(
                     width: 200,
                      //height: 10,
                      decoration: BoxDecoration(
                          color: HexColor(hexColor),
                          border: Border.all(color: Colors.black26)
                      ),
                      child: Center(child: Text(" Color :- ${getAllDAta[index]['color'].toString()}")),
                    ),
                    Row(
                      children: [



                      ],
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
