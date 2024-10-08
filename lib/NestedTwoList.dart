import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart'as http;

class NestedTowListPage extends StatefulWidget {
  const NestedTowListPage({super.key});

  @override
  State<NestedTowListPage> createState() => _NestedTowListPageState();
}


class _NestedTowListPageState extends State<NestedTowListPage> {
  late final Future<List<LanguageNoModel>> civilDataList;
  Future<List<LanguageNoModel>> civilDataApi()async{
    final apiResponse = await http.get(Uri.parse("https://restcountries.com/v3.1/independent?status=true&fields=languages,capital"));

    if(apiResponse.statusCode==200){
      List cvDataList = jsonDecode(apiResponse.body);
      print("Response :- ${cvDataList}");
      return cvDataList.map((e) => LanguageNoModel.fromJson(e)).toList();
    }else{
      throw Exception("data Not found");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    civilDataList = civilDataApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tow Nested Api"),centerTitle: true,),
      body: FutureBuilder<List<LanguageNoModel>>(
        future: civilDataList,
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
          }else if(snapshot.hasError){
            return Text("Some Error Found ${snapshot.hasError}");
          }else if(!snapshot.hasData ||snapshot.data!.isEmpty){
            return Text("No Data Found");
          }else{
            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Name :-  "),
                                ],
                              )),
                              Expanded(
                                flex: 3,
                                  child: Text("${snapshot.data![index].capital.join(", ")}"))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Language :-  "),
                                ],
                              )),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: snapshot.data![index].languages.values.map((e) => Text(e)).toList(),
                                ),
                              ),
                            ],
                          ),
                         // Text("${snapshot.data![index].languages.values.join(", ")}")
                        ],
                      ),
                    ),
                  );
                }),
            );
          }
        },
      ),
    );
  }
}

class LanguageNoModel{
  late List<String> capital;
  late  Map<String,String> languages;

  LanguageNoModel({required this.capital,required this.languages});
  factory LanguageNoModel.fromJson(Map<String,dynamic>json){
    return LanguageNoModel(
        capital: List<String>.from(json["capital"]),
        languages:Map<String,String>.from(json["languages"]));
  }
}
