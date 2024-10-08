import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class NestedArryDemoApiPage extends StatefulWidget {
  const NestedArryDemoApiPage({super.key});

  @override
  State<NestedArryDemoApiPage> createState() => _NestedArryDemoApiPageState();
}

class _NestedArryDemoApiPageState extends State<NestedArryDemoApiPage> {
    late Future<NestedArrayApiModel> nestedArrayApiList;
    
    Future<NestedArrayApiModel> _nestedArryApi()async{
      final apiResponse = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));

      if(apiResponse.statusCode==200){
        final Map<String,dynamic> dataResponse =jsonDecode(apiResponse.body);
        log("Api Response :- $dataResponse");
        return NestedArrayApiModel.fromJson(dataResponse);
      }else{
        throw Exception("No Data Found");
      }
    }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nestedArrayApiList=_nestedArryApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8f8fad),
      appBar: AppBar(title: const Text("Nested Array Demo Api"),centerTitle: true,backgroundColor: Colors.lightBlue,),
      body: Container(
        child: FutureBuilder<NestedArrayApiModel>(
          future: nestedArrayApiList,
          builder: (context,snapshot){
            log("Future Api Response $nestedArrayApiList");
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: LinearProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Error Found ${snapshot.hasError}");
            }else if(snapshot.hasData){
              return Column(
                children: [
                    Text("Page :- ${snapshot.data!.page}"),
                    Text("Par Page :- ${snapshot.data!.per_page}"),
                    Text("Total :- ${snapshot.data!.total}"),
                    Text("Total Page :- ${snapshot.data!.total_pages}"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/1.4,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context,index){
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                               Expanded(
                                 flex: 3,
                                 child: Container(

                                   decoration: BoxDecoration(
                                       color: Colors.orangeAccent.shade100,
                                     //border: Border.all(color: Colors.black26),
                                     borderRadius: const BorderRadius.all(Radius.circular(10))
                                   ),
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Row(
                                       children: [
                                         const Expanded(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                             Text("Id :-",style: TextStyle(fontSize: 13),),
                                             Text("Email :-",style: TextStyle(fontSize: 13),),
                                             Text("First Name :-",style: TextStyle(fontSize: 13),),
                                             Text("Last Name :-",style: TextStyle(fontSize: 13),),
                                           
                                           ],),
                                         ),
                                         Expanded(
                                           flex: 2,
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(snapshot.data!.data![index].id.toString(),style: const TextStyle(fontSize: 13),),
                                               Text(snapshot.data!.data![index].email.toString(),style: const TextStyle(fontSize: 13),),
                                               Text(snapshot.data!.data![index].first_name.toString(),style: const TextStyle(fontSize: 13),),
                                               Text(snapshot.data!.data![index].last_name.toString(),style: const TextStyle(fontSize: 13),),
                                             ],
                                           ),
                                         )


                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onDoubleTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Hero(
                                            tag: snapshot.data!.data![index].id.toString(),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data!.data![index].avatar.toString(),
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

                                                child: CachedNetworkImage(imageUrl: snapshot.data!.data![index].avatar.toString(),
                                                                                   placeholder: (context,url)=>const Center( widthFactor:10.1,child: LinearProgressIndicator()),
                                                errorWidget: (context,url,error)=>const Icon(Icons.error),height: 88,width: 88,fit: BoxFit.cover,),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],)
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            }else{
              return const Text("Not Data Found");
            }
          },
        ),
      ),
    );
  }
}
class NestedArrayApiModel{
  final int? page;
  final int? per_page;
  final int? total;
  final int? total_pages;
  final List<EmployeeData>? data;
  final Support? support;
  NestedArrayApiModel({required this.page,required this.per_page,required this.total,required this.total_pages,required this.data,required this.support});
  factory NestedArrayApiModel.fromJson(Map<String,dynamic>json){
      List empList = json["data"];
      List<EmployeeData> empDataList = empList.map((e) => EmployeeData.fromJson(e)).toList();
      return NestedArrayApiModel(
          page: json["page"],
          per_page: json["per_page"],
          total: json["total"],
          total_pages: json["total_pages"],
          data: empDataList,
          support: Support.fromJson(json["support"]),);
  }
}

class EmployeeData {
   final int? id;
   final String? email;
   final String? first_name;
   final String? last_name;
   final String? avatar;

   EmployeeData({required this.id,required this.email,required this.first_name,required this.last_name,required this.avatar});
   factory EmployeeData.fromJson(Map<String,dynamic>json){
     return EmployeeData(
         id: json["id"],
         email: json["email"],
         first_name: json["first_name"],
         last_name: json["last_name"],
         avatar: json["avatar"]);
   }
}
class Support{
  final String? url;
  final String? text;
  Support({required this.url,required this.text});
  factory Support.fromJson(Map<String,dynamic>json){
    return Support(url: json["url"], text: json["text"]);
  }
}