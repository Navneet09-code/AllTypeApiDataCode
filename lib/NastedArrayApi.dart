import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class NestedArrayApi extends StatefulWidget {
  const NestedArrayApi({super.key});

  @override
  State<NestedArrayApi> createState() => _NestedArrayApiState();
}

class _NestedArrayApiState extends State<NestedArrayApi> {
 late Future<Country> countryList;
 Future<Country>_countryIdsApi()async{
   final apiDataResponse = await http.get(Uri.parse("https://api.nationalize.io/?name=nathaniel"));

   if(apiDataResponse.statusCode==200){
     final Map<String,dynamic> dataResponse = jsonDecode(apiDataResponse.body);
     return Country.fromJson(dataResponse);
   }else{
     throw Exception("Network Error Or Check Api Response");
   }
 }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryList=_countryIdsApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nested Array Api"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<Country>(
          future: countryList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Found Some Error Check Api ${snapshot.hasError}");
            }else if(snapshot.hasData){
              return  SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Count :- ${snapshot.data!.count}"),
                    Text("Name :- ${snapshot.data!.name}"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.country!.length,
                          itemBuilder: (context,index){
                
                            return Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26)
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Country Id :- "),
                                        Text("Probability :- "),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${snapshot.data!.country![index].country_id}"),
                                          Text("${snapshot.data!.country![index].probability}"),
                
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }else{
              return const Text("No Data Found");
            }
          },
        )
      ),
    );
  }
}
class Country{
  final int? count;
  final String? name;
  final List<CountryId>? country;
  Country({required this.count,required this.name,required this.country});
  factory Country.fromJson(Map<String,dynamic>json){
    List countryData = json['country'];
    List<CountryId> countryId = countryData.map((e) => CountryId.fromJson(e)).toList();
    return Country(count: json["count"], name: json["name"], country: countryId);

  }
}
class CountryId{
  final String? country_id;
  final double? probability;
  CountryId({ required this.country_id,required this.probability});
  factory CountryId.fromJson(Map<String,dynamic>json){
    return CountryId(country_id: json["country_id"], probability: json["probability"]);
  }
}