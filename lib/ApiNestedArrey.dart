import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class NestedArrayDemo extends StatefulWidget {
  const NestedArrayDemo({super.key});

  @override
  State<NestedArrayDemo> createState() => _NestedArrayDemoState();
}

class _NestedArrayDemoState extends State<NestedArrayDemo> {
  late Future<NestedArry> nestedArryList;
  Future<NestedArry> _nestedArrayApi()async{
    final responceData = await http.get(Uri.parse("https://dummy.restapiexample.com/api/v1/employees"));
    if(responceData.statusCode==200){
      final Map<String,dynamic> apiResponse = jsonDecode(responceData.body);
      return NestedArry.fromJson(apiResponse);
    }else{
      throw Exception('No Data Found');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nestedArryList =_nestedArrayApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nested Arry"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<NestedArry>(
          future: nestedArryList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return Text("Error ${snapshot.hasError}");
            }else if(snapshot.hasData || snapshot.data!.status=="status"){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Status Type = ${snapshot.data!.status}"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/2,
                      child: ListView.builder(
                         shrinkWrap: true,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context,index){
                        return Container(
                          child: Column(
                            children: [
                              Text(" ID :- ${snapshot.data!.data![index].id}"),
                              Text(" Name :- ${snapshot.data!.data![index].employee_name}"),
                              Text(" Profile Image :- ${snapshot.data!.data![index].profile_image!=""?snapshot.data!.data![index].profile_image:"No image found"}"),
                            ],
                          ),
                        );
                      }),
                    ),
                    Text("Message = ${snapshot.data!.message}"),
                  ],
                ),
              );
            }else{
              return const Text("No Found Data");
            }
          },
        ),
      ),
    );
  }
}
class NestedArry{

  final String? status;
  final List<Employee>? data;
  final String? message;


  NestedArry({required this.status,required this.data,required this.message});
  factory NestedArry.fromJson(Map<String,dynamic>json){
     List dataList = json["data"];
     List<Employee> empList = dataList.map((e) => Employee.fromJson(e)).toList();
    return NestedArry(
        status: json["status"],
        data: empList,
        message: json["message"],
        );
  }
}
class Employee{
  final int? id;
  final String? employee_name;
  final int? employee_salary;
  final int? employee_age;
  final String? profile_image;
  Employee({
    required this.id,
    required this.employee_name,
    required this.employee_salary,
    required this.employee_age,
    required this.profile_image});
  factory Employee.fromJson(Map<String,dynamic>json){
    return Employee(
        id: json["id"],
        employee_name: json["employee_name"],
        employee_salary: json["employee_salary"],
        employee_age: json["employee_age"],
        profile_image: json["profile_image"]);
  }
}
