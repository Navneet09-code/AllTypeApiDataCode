import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ListAndObjectApiPage extends StatefulWidget {
  const ListAndObjectApiPage({super.key});

  @override
  State<ListAndObjectApiPage> createState() => _ListAndObjectApiPageState();
}

class _ListAndObjectApiPageState extends State<ListAndObjectApiPage> {
  late Future<EmpDataModel> empDataList;
  Timer? _timer;

  Future<EmpDataModel> _empDataApi()async{
    final dataResponse =  await http.get(Uri.parse("https://randomuser.me/api/"));

    if(dataResponse.statusCode==200){
      final Map<String,dynamic> empDataList = jsonDecode(dataResponse.body);
      setState(() {

      });
      log("${empDataList}");
      return EmpDataModel.fromJson(empDataList);

    }else{
      throw Exception("Check Api Response");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startAutoRefresh();
    empDataList= _empDataApi();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    // Set the timer to refresh every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      empDataList= _empDataApi();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List And Object'),centerTitle: true,),
      body: Container(
        child: FutureBuilder<EmpDataModel>(
          future:empDataList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Some Error ${snapshot.hasError}");
            }else if(snapshot.hasData){
              return Column(
                children: [
                  Expanded(
                    flex: 2,
                      child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.result!.length,
                      itemBuilder: (context,index){
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Gender : ${snapshot.data!.result![index].gender}"),
                                  Text(" Title : ${snapshot.data!.result![index].name!.title}"),
                                  Text(" First Name : ${snapshot.data!.result![index].name!.first}"),
                                  Text(" Last Name : ${snapshot.data!.result![index].name!.last}"),
                                ],
                              )),
                              Expanded(
                                child: Center(
                                  child: Container(
                                  margin: EdgeInsets.only(top: 5,bottom: 5,right: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                     // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //Text("Picture"),
                                        SizedBox(
                                            height: 80,width: 80,
                                            child: CachedNetworkImage(
                                              imageUrl:snapshot.data!.result![index].picture!.large.toString() ,
                                              placeholder: (context,url)=>const CircularProgressIndicator(),
                                              errorWidget: (context,url,error)=>const Icon(Icons.error),)

                                        ),

                                      ],
                                    ),
                                  ),
                                                                ),
                                ),)
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5,bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Location Details : "),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(strokeAlign: BorderSide.strokeAlignOutside)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Street Details :"),
                                        Row(
                                          children: [
                                            Text(" Number : ${snapshot.data!.result![index].location!.street!.number}"),
                                            Text(" Name : ${snapshot.data!.result![index].location!.street!.name}"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(" City : ${snapshot.data!.result![index].location!.city}"),
                                  Text(" State : ${snapshot.data!.result![index].location!.state}"),
                                  Text(" Country : ${snapshot.data!.result![index].location!.country}"),
                                  Text(" Post Code : ${snapshot.data!.result![index].location!.postcode}"),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(strokeAlign: BorderSide.strokeAlignOutside)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Coordinates Details :"),
                                        Row(
                                          children: [
                                            Text(" Latitude : ${snapshot.data!.result![index].location!.coordinates!.latitude}"),
                                            Text(" Longitude : ${snapshot.data!.result![index].location!.coordinates!.longitude}"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    
                                    margin: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(strokeAlign: BorderSide.strokeAlignOutside)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Time Zone Details :"),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: Text(" Offset : ${snapshot.data!.result![index].location!.timezon!.offset}")),
                                            Expanded(
                                              flex: 2,
                                                child: Text("Discription : ${snapshot.data!.result![index].location!.timezon!.description}")),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(" Email : ${snapshot.data!.result![index].email}"),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Login Details : "),
                                  Text(" UUID : ${snapshot.data!.result![index].login!.uuid!}"),
                                  Text(" Username : ${snapshot.data!.result![index].login!.username!}"),
                                  Text(" Password : ${snapshot.data!.result![index].login!.password!}"),
                                  Text(" Salt : ${snapshot.data!.result![index].login!.salt!}"),
                                  Text(" MD5 : ${snapshot.data!.result![index].login!.md5!}"),
                                  Text(" SHA1 : ${snapshot.data!.result![index].login!.sha1!}"),
                                  Text(" SHA256 : ${snapshot.data!.result![index].login!.sha256!}"),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Dob Details : "),
                                  Text(" Date : ${snapshot.data!.result![index].dob!.date}"),
                                  Text(" Age : ${snapshot.data!.result![index].dob!.age}"),

                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5,bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Registered Details : "),
                                  Text(" Date : ${snapshot.data!.result![index].registered!.date}"),
                                  Text(" Age : ${snapshot.data!.result![index].registered!.age}"),

                                ],
                              ),
                            ),
                          ),
                          Text(" Phone : ${snapshot.data!.result![index].phone}"),
                          Text(" Cell : ${snapshot.data!.result![index].phone}"),
                          Container(
                            margin: EdgeInsets.only(top: 5,bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID Details : "),
                                  Text(" Name : ${snapshot.data!.result![index].id!.name!=""?snapshot.data!.result![index].id!.name:"No Name Found"}"),
                                  Text(" Value : ${snapshot.data!.result![index].id!.value!=null?snapshot.data!.result![index].id!.value:"No Value Found"}"),

                                ],
                              ),
                            ),
                          ),

                          Text(" Nat : ${snapshot.data!.result![index].nat}"),

                        ],
                      ),
                    );
                  })),
                   Expanded(
                     child: Container(
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dob Details : "),
                          Text(" Seed : ${snapshot.data!.info!.seed}"),
                          Text(" Results : ${snapshot.data!.info!.results}"),
                          Text(" Page : ${snapshot.data!.info!.page}"),
                          Text(" Version : ${snapshot.data!.info!.version}"),

                        ],
                      ),
                    ),
                  ),)
                ],
              );
            } else{
              return const Text("No Data Found");
            }
          },

        ),
      ),
    );
  }
}
class EmpDataModel{
  final List<EmpDetailModel>? result;
  final InformationModel? info;
 EmpDataModel({required this.result,required this.info});
 factory EmpDataModel.fromJson(Map<String,dynamic>json){
   List dataList = json["results"];
   List<EmpDetailModel> empDataList = dataList.map((e) => EmpDetailModel.fromJson(e)).toList();
   return EmpDataModel(result: empDataList, info: InformationModel.fromJson(json["info"]));
 }
}
class EmpDetailModel{
     final String? gender;
     final NameModel? name;
     final LocationModel? location;
     final String? email;
     final LoginModel? login;
     final DOBModel? dob;
     final RegisteredModel? registered;
     final String? phone;
     final String? cell;
     final IDModel? id;
     final PictureModel? picture;
     final String? nat;
     EmpDetailModel({
       required this.gender,
     required this.name,
     required this.location,
     required this.email,
     required this.login,
     required this.dob,
       required this.registered,
     required this.phone,
     required this.cell,
     required this.picture,
     required this.id,
     required this.nat});
     factory EmpDetailModel.fromJson(Map<String,dynamic>json){
       return EmpDetailModel(
           gender: json["gender"],
           name: NameModel.fromJson(json["name"]),
           location: LocationModel.fromJson(json["location"]),
           email: json["email"],
           login: LoginModel.fromJson(json["login"]),
           dob: DOBModel.fromJson(json["dob"]),
           registered: RegisteredModel.fromJson(json["registered"]),
           phone: json["phone"],
           cell: json["cell"],
           picture: PictureModel.fromJson(json["picture"]),
           id: IDModel.fromJson(json["id"]),
           nat: json["nat"]);
     }
}
class NameModel{
  final String? title;
  final String? first;
  final String? last;
  NameModel({required this.title,required this.first,required this.last});
  factory NameModel.fromJson(Map<String,dynamic>json){
    return NameModel(title: json["title"], first: json["first"], last: json["last"]);
  }
}
class LocationModel{
  final StreetLocationModel? street;
  final String? city;
  final String? state;
  final String? country;
  final dynamic postcode;
  final LocationCordiModel? coordinates;
  final LocationTimeZoneModel? timezon;
  LocationModel({
    required this.street,
  required this.city,
  required this.state,
  required this.country,
  required this.postcode,
  required this.coordinates,
  required this.timezon});
  factory LocationModel.fromJson(Map<String,dynamic>json){
    return LocationModel(
        street: StreetLocationModel.fromJson(json["street"]),
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postcode: json["postcode"],
        coordinates: LocationCordiModel.fromJson(json["coordinates"]),
        timezon: LocationTimeZoneModel.fromJson(json["timezone"]));
  }
}
class StreetLocationModel{
  final int? number;
  final String? name;
  StreetLocationModel({ required this.number,required this.name});
  factory StreetLocationModel.fromJson(Map<String,dynamic>json){
    return StreetLocationModel(number: json["number"], name: json["name"]);
  }
}
class LocationCordiModel{
  final String? latitude;
  final String? longitude;
  LocationCordiModel({required this.latitude,required this.longitude});
  factory LocationCordiModel.fromJson(Map<String,dynamic>json){
    return LocationCordiModel(latitude: json["latitude"], longitude: json["longitude"]);
  }
}
class LocationTimeZoneModel{
  final String? offset;
  final String? description;
  LocationTimeZoneModel({required this.offset,required this.description});
  factory LocationTimeZoneModel.fromJson(Map<String,dynamic>json){
    return LocationTimeZoneModel(offset: json["offset"], description: json["description"]);
  }
}

class LoginModel{
   final String? uuid;
   final String? username;
   final String? password;
   final String? salt;
   final String? md5;
   final String? sha1;
   final String? sha256;

   LoginModel({
     required this.uuid,
   required this.username,
   required this.password,
   required this.salt,
   required this.md5,
   required this.sha1,
   required this.sha256});
   factory LoginModel.fromJson(Map<String,dynamic>json){
     return LoginModel(
         uuid: json["uuid"],
         username: json["username"],
         password: json["password"],
         salt: json["salt"],
         md5: json["md5"],
         sha1: json["sha1"],
         sha256: json["sha256"]);
   }
}

class DOBModel{
   final String? date;
   final int? age;
   DOBModel({required this.date,required this.age});
   factory DOBModel.fromJson(Map<String,dynamic>json){
     return DOBModel(date: json["date"], age: json["age"]);
   }
}

class RegisteredModel {
  final String? date;
  final int? age;

  RegisteredModel({required this.date, required this.age});

  factory RegisteredModel.fromJson(Map<String, dynamic>json){
    return RegisteredModel(date: json["date"], age: json["age"]);
  }
}

class IDModel{
  final String? name;
  final dynamic value;
  IDModel({required this.name,required this.value});
  factory IDModel.fromJson(Map<String,dynamic>json){
    return IDModel(name: json["name"], value: json["value"]);
  }
}

class PictureModel{
  final String? large;
  final String? medium;
  final String? thumbnail;
  PictureModel ({required this.large,required this.medium,required this.thumbnail});
  factory PictureModel.fromJson(Map<String,dynamic>json){
    return PictureModel(large: json["large"], medium: json["medium"], thumbnail: json["thumbnail"]);
  }
}

class InformationModel{
  final String? seed;
  final int? results;
  final int? page;
  final String? version;

  InformationModel({required this.seed,required this.results,required this.page,required this.version});
  factory InformationModel.fromJson(Map<String,dynamic>json){
    return InformationModel(seed: json["seed"], results: json["results"], page: json["page"], version: json["version"]);
  }
}
