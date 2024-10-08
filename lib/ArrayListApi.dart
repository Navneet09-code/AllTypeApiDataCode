import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArrayListApiPage extends StatefulWidget {
  const ArrayListApiPage({super.key});

  @override
  State<ArrayListApiPage> createState() => _ArrayListApiPageState();
}

class _ArrayListApiPageState extends State<ArrayListApiPage> {
  late Future<PopulationModel> polulationList;
   Future<PopulationModel> _populationDataApi() async{
       final apiDataResponce = await http.get(Uri.parse("https://datausa.io/api/data?drilldowns=Nation&measures=Population"));

       if(apiDataResponce.statusCode==200){
         print("Status Code :- ${apiDataResponce.statusCode}");
       // List _popList = jsonDecode(apiDataResponce.body);
        final Map<String,dynamic> apiRespo=jsonDecode(apiDataResponce.body);
         print('Api response $apiRespo');
        // return _popList.map((e) => PopulationModel.fromJson(e)).toList();
         return  PopulationModel.fromJson(apiRespo);
       }else{
         throw Exception("No Data Found Check Api response");
       }
   }
   /*_apiData()async{
     final apiDataResponce = await http.get(Uri.parse("https://datausa.io/api/data?drilldowns=Nation&measures=Population"));
     if(apiDataResponce.statusCode==200){
       List dataFile= jsonDecode(apiDataResponce.body);
       print("Api DAta Res ${dataFile}");
     }
   }*/
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polulationList=_populationDataApi();
    /*_apiData();*/
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Array List Api"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<PopulationModel>(
          future:polulationList,
          builder: (context,snapshot){

            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Some Error ${snapshot.hasError}");
            } else if(snapshot.hasData){
              final populationData=snapshot.data!.data;
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: populationData!.length,
                          itemBuilder: (context,Dindex){

                        return Container(
                          child: Column(
                            children: [
                              Text("Id Nation :- ${populationData[Dindex].Nation}")
                            ],
                          ),
                        );
                      }),
                    ),
                    Expanded(
                      child: ListView.builder(itemBuilder: (context,index){
                        return Container(
                          child:  Column(
                            children: [

                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }else{
              return  Text("No Data Found");
            }
          },
        ),
      ),
    );
  }
}
class PopulationModel{
  List<PopulationData>? data;
  List<PopulationSource>? source;
  PopulationModel({required this.data,required this.source});
  factory PopulationModel.fromJson(Map<String,dynamic>json){
    var dataList = json["data"] as List;
    var dataSource =json["source"] as List;
    List<PopulationData> populationData = dataList.map((e) => PopulationData.fromJson(e)).toList();
    List<PopulationSource> populationSource = dataSource.map((e) => PopulationSource.fromJson(e)).toList();
    return PopulationModel(data: populationData,source: populationSource);
  }
}
class PopulationData{
  final String? IDNation;
  final String? Nation;
  final int? IDYear;
  final String? Year;
  final int? Population;
  final String? SlugNation;

  PopulationData({
    required this.IDNation,
    required this.Nation,
    required this.IDYear,
    required this.Year,
    required this.Population,
    required this.SlugNation});
  factory PopulationData.fromJson(Map<String,dynamic>json){
    return PopulationData(
        IDNation: json["ID Nation"],
        Nation: json["Nation"],
        IDYear: json["ID Year"],
        Year: json["Year"],
        Population: json["Population"],
        SlugNation: json["Slug Nation"]);
  }
}
class PopulationSource{
     final List<String>? measures;
     final Annotation? annotation;
     final String? name;
     final List<dynamic>? substitution;
     PopulationSource({ required this.measures,required this.annotation,required this.name,required this.substitution});
     factory PopulationSource.fromJson(Map<String,dynamic>json){
       //List srcData= json["measures"];
       //List subData=json['substitution'];
       //List<SourceData> sourceData= srcData.map((e) => SourceData.fromJson(e)).toList();
       //List<Null> subsitutData= subData.map((e) => Subsitution.fromJson(e)).toList();
       return PopulationSource(
           measures: json["measures"],
           annotation: Annotation.fromJson(json["annotations"]),
           name: json["name"],
           substitution:json["substitutions"]
       );
     }
}
class SourceData{

}
class Subsitution{}
class Annotation{
  final String? source_name;
  final String? source_description;
  final String? dataset_name;
  final String? dataset_link;
  final String? table_id;
  final String? topic;
  final String? subtopic;

  Annotation({
    required this.source_name,
    required this.source_description,
    required this.dataset_name,
    required this.dataset_link,
    required this.table_id,
    required this.topic,
    required this.subtopic});
  factory Annotation.fromJson(Map<String,dynamic>json){
    return Annotation(
        source_name: json["source_name"],
        source_description: json["source_description"],
        dataset_name: json["dataset_name"],
        dataset_link: json["dataset_link"],
        table_id: json["table_id"],
        topic: json["topic"],
        subtopic: json["subtopic"]);
  }

}