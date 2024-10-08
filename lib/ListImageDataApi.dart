import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ImageDataApiPage extends StatefulWidget {
  const ImageDataApiPage({super.key});

  @override
  State<ImageDataApiPage> createState() => _ImageDataApiPageState();
}

class _ImageDataApiPageState extends State<ImageDataApiPage> {
  late Future<List<UserDataModel>> userDataList;
  double fontSize=10;
  Timer? _timer;

  Future<List<UserDataModel>> _userDataModelApi()async{
    final apiResponse = await http.get(Uri.parse("https://fake-json-api.mock.beeceptor.com/users"));

    if(apiResponse.statusCode==200){
      log("API :- ${apiResponse}");
      log("API RESPONSE :- ${apiResponse.body}");
      List userApiList = jsonDecode(apiResponse.body);
      setState(() {

      });
      return userApiList.map((e) => UserDataModel.fromJson(e)).toList();
    }else{
      throw Exception("Check Api Response Or Data Connection");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDataList=_userDataModelApi();
    _startAutoRefresh();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  void _startAutoRefresh() {
    // Set the timer to refresh every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      userDataList= _userDataModelApi();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc2bebe),
      appBar: AppBar(title: Text("Image Data Api"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<List<UserDataModel>>(
          future: userDataList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Found Error ${snapshot.hasError}");
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Text('No Data Found');
            }else{
              return Container(

                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                    var userData = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12,bottom: 20,top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(color: Color(0xffe8e0e0),
                                blurStyle: BlurStyle.inner,
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(3,5)),
                            BoxShadow(color: Colors.black54,
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(-4,-4)),
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12)
                                  ),
                                  child: Row(

                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:15,bottom: 15,left: 5),
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,

                                            children: [
                                              Text("User Id :- ",style: TextStyle(fontSize: fontSize)),
                                              Text("Name :-",style: TextStyle(fontSize: fontSize)),
                                              Text("Company Name :-",style: TextStyle(fontSize: fontSize),),
                                              Text("User Name :-",style: TextStyle(fontSize: fontSize),),
                                              Text("Email :-",style: TextStyle(fontSize: fontSize),),
                                              Text("Address :-",style: TextStyle(fontSize: fontSize),),
                                              Text("Zip :-",style: TextStyle(fontSize: fontSize),),
                                              Text("State :-",style: TextStyle(fontSize: fontSize),),
                                              Text("Country :-",style: TextStyle(fontSize: fontSize),),
                                              Text("Phone :-",style: TextStyle(fontSize: fontSize),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                           // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("  ${userData.id}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.name}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.company}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.username}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.email}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.address}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.zip}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.state}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.country}",style: TextStyle(fontSize: fontSize)),
                                            Text("  ${userData.phone}",style: TextStyle(fontSize: fontSize)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: GestureDetector(
                                    onDoubleTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Hero(
                                            tag: snapshot.data![index].id.toString(),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data![index].photo.toString(),
                                              placeholder: (context, url) => const CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(10)) ,
                                              child: Container(
                                                //height: 80,width: 80,
                                  
                                                child: CachedNetworkImage(imageUrl: snapshot.data![index].photo.toString(),
                                                  placeholder: (context,url)=>const Center( widthFactor:10.1,child: LinearProgressIndicator()),
                                                  errorWidget: (context,url,error)=>const Icon(Icons.error),height: 88,width: 88,fit: BoxFit.cover,),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }
          },
        ),
      ),
    );
  }
}
class UserDataModel{
   final int? id;
   final String? name;
   final String? company;
   final String? username;
   final String? email;
   final String? address;
   final String? zip;
   final String? state;
   final String? country;
   final String? phone;
   final String? photo;

   UserDataModel({
     required this.id,
     required this.name,
     required this.company,
     required this.username,
     required this.email,
     required this.address,
     required this.zip,
     required this.state,
     required this.country,
     required this.phone,
     required this.photo});
   factory UserDataModel.fromJson(Map<String,dynamic>json){
     return UserDataModel(
         id: json["id"],
         name: json["name"],
         company: json["company"],
         username: json["username"],
         email: json["email"],
         address: json["address"],
         zip: json["zip"],
         state: json["state"],
         country: json["country"],
         phone: json["phone"],
         photo: json["photo"]);
   }
}