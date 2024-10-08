import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart'as http;
import 'package:url_launcher/url_launcher.dart';

class TowListDataApiPage extends StatefulWidget {
  const TowListDataApiPage({super.key});

  @override
  State<TowListDataApiPage> createState() => _TowListDataApiPageState();
}

class _TowListDataApiPageState extends State<TowListDataApiPage> {
  late Future<List<StudentModel>> sudentModelList;
  TextEditingController _controller = TextEditingController();

  Future<List<StudentModel>> _sudentModelApi(String query)async{
    final responseData = await http.get(Uri.parse("http://universities.hipolabs.com/search?name=$query"));

    if(responseData.statusCode==200){
      List<dynamic> stdDataList = jsonDecode(responseData.body);
      return stdDataList.map((e) => StudentModel.fromJson(e)).toList();
    }else{
      throw Exception("Check Api Response");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
_search();
  }
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void _search() {
    setState(() {

      sudentModelList = _sudentModelApi(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Two List Data"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<List<StudentModel>>(
          future: sudentModelList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Some Error ${snapshot.hasError}");
            }else if(!snapshot.hasData||snapshot.data!.isEmpty){
              return Text("No data");
            }else{
              final stdData =snapshot.data;
              return SingleChildScrollView(
                child: Column(
                
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 40,
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                           // _filterSearchResults(value);
                          },
                          onSubmitted: (value){
                            _search();
                          },
                          decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search by college name",
                            contentPadding: EdgeInsets.only(top: 10),
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            ),
                            /*suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _search,
                            ),*/
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: ListView.builder(
                        shrinkWrap: true,
                          itemCount: stdData!.length,
                          itemBuilder: (context,index){
                
                            return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text("Collage Name  :-")),
                                        Expanded(
                                          flex: 2,
                                            child: Text(" ${stdData[index].name}")),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                     // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text("Alpha two Code  :-",style: TextStyle(fontSize: 12),)),
                                        Expanded(
                                            flex: 2,
                                            child: Text(" ${stdData[index].alpha_two_code}")),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text("Country  :-",)),
                                        Expanded(
                                            flex: 2,
                                            child: Text(" ${stdData[index].country}")),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text("State Province  :-",style: TextStyle(fontSize: 12),)),
                                        Expanded(
                                            flex: 2,
                                            child: Text(" ${stdData[index].stateprovince!=""?stdData[index].stateprovince:"No data availble"}")),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text("Domains  :-",style: TextStyle(fontSize: 12),)),
                                        Expanded(
                                            flex: 2,
                                            child: ConstrainedBox(
                                              constraints: new BoxConstraints(
                                                minHeight: 5.0,
                                                minWidth: 5.0,
                                                maxHeight: 35.0,
                                                maxWidth: 30.0,
                                              ),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                  itemCount: stdData[index].domains!.length,
                                                  itemBuilder: (context,Dindex){
                                                   final data=stdData[index].domains![Dindex];
                                                return Container(
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(" ${data.toString()}")
                                                    ],
                                                  ) ,
                                                );
                                              }),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text("University Website  :-",style: TextStyle(fontSize: 12),)),
                                        Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              height: 50,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: stdData[index].web_pages!.length,
                                                  itemBuilder: (context,Windex){
                                                    final data=stdData[index].web_pages![Windex];
                                                    return GestureDetector(
                                                      onTap: (){
                                                        _launchURL(data.toString());
                                                      },
                                                      child: Container(
                                                        child:Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(" ${data.toString()}" ,style: TextStyle(
                                                      color: Colors.blue,
                                                        decoration: TextDecoration.underline,
                                                      ),)
                                                          ],
                                                        ) ,
                                                      ),
                                                    );
                                                  }),
                                            )),
                                      ],
                                    ),
                                  ),
                
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
class StudentModel{
  final String? alpha_two_code;
  final String? name;
  final List<dynamic>? domains;
  final List<String>? web_pages;
  final String? country;
  final String? stateprovince;
  StudentModel({required this.alpha_two_code,required this.name,required this.domains,required this.web_pages,required this.country,required this.stateprovince});
  factory StudentModel.fromJson(Map<String,dynamic>json){
  /*  List dModel= json["domains"];
    List wPageModel =json["web_pages"];
    List<DomainsModel> domModel = dModel.map((e) => DomainsModel.fromJson(e)).toList();
    List<WebPageModel> webPageModel = wPageModel.map((e) => WebPageModel.fromJson(e)).toList();*/
    return StudentModel(
        alpha_two_code: json["alpha_two_code"],
        name: json["name"],
        domains: List<String>.from(json["domains"]),
        web_pages: List<String>.from(json["web_pages"]),
        country: json["country"],
        stateprovince: json["state-province"]!=null?json["state-province"]:""
    );
  }
}
