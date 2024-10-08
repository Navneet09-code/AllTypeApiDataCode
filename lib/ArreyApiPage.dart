import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ArrayApiPage extends StatefulWidget {
  const ArrayApiPage({super.key});

  @override
  State<ArrayApiPage> createState() => _ArrayApiPageState();
}

class _ArrayApiPageState extends State<ArrayApiPage> {
  late Future<List<UserDetails>> userDetailList;
  Future<List<UserDetails>> _userDetailsApi() async{
    final response = await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if(response.statusCode==200){
      List responseData = jsonDecode(response.body);
      return responseData.map((e) => UserDetails.fromJson(e)).toList();
    }else{
      throw Exception("No Data Found");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDetailList =_userDetailsApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Array Api Data"),centerTitle: true,),
      body: Container(
 child:  FutureBuilder<List<UserDetails>>(
   future: userDetailList,
   builder: (context,snapshot){
     if(snapshot.connectionState==ConnectionState.waiting){
       return const CircularProgressIndicator();
     }else if(snapshot.hasError){
       return Text("Error occurd ${snapshot.hasError}");
     }else if(!snapshot.hasData || snapshot.data!.isEmpty){
       return const Text("No data found");
     }else{
       return ListView.builder(itemBuilder: (context, index) {
         return Container(
           child: Column(
             children: [
               Text("User Id :- ${snapshot.data![index].userId}"),
               Text(" Id :- ${snapshot.data![index].userId}"),
               Text(" Title :- ${snapshot.data![index].title}"),
               Text(" Body :- ${snapshot.data![index].body}"),
             ],
           ),
         );
       });
     }
   },
 ),
      ),
    );
  }
}
class UserDetails{
  final int? userId;
  final int? id;
  final String? title;
  final String? body;
   UserDetails({required this.userId,required this.id,required this.title,required this.body});
   factory UserDetails.fromJson(Map<String,dynamic>json){
     return UserDetails(
         userId: json["userId"],
         id: json["id"],
         title: json["title"],
         body: json["body"]);
   }
}
