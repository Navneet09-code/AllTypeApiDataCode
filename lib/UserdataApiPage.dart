import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class UserdataApiPage extends StatefulWidget {
  const UserdataApiPage({super.key});

  @override
  State<UserdataApiPage> createState() => _UserdataApiPageState();
}

class _UserdataApiPageState extends State<UserdataApiPage> {
  late Future<List<UserDataModel>> userDataList;
  
  Future<List<UserDataModel>> userDataApi()async{
    final apiResponse = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
    if(apiResponse.statusCode==200){
      List responceData = jsonDecode(apiResponse.body);
      return responceData.map((e) => UserDataModel.fromJson(e)).toList();
    }else{
      throw Exception("Data Not Found");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDataList=userDataApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User data"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<List<UserDataModel>>(
          future: userDataList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Some Error ${snapshot.hasError}");
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return const Text("No Data Found");
            }else{
              return ListView.builder(itemBuilder: (context,index){
                return Column(
                  children: [
                    Text("User Id :- ${snapshot.data![index].postId}"),
                    Text("Id :- ${snapshot.data![index].id}"),
                    Text("Name :- ${snapshot.data![index].name}"),
                    Text("Email :- ${snapshot.data![index].email}"),
                    Text("Body :- ${snapshot.data![index].body}"),
                  ],
                );
              });
            }
          },
        ),
      ),
    );
  }
}
class UserDataModel{
   final int? postId;
   final int? id;
   final String? name;
   final String? email;
   final String? body;
   UserDataModel({required this.postId,required this.id,required this.name,required this.email,required this.body});
   factory UserDataModel.fromJson(Map<String,dynamic>json){
     return UserDataModel(
     postId: json["postId"], 
   id: json["id"], 
   name: json["name"], 
   email: json["email"], 
   body: json["body"]);
   }
   }
