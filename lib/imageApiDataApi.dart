import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class ImageApiDataPage extends StatefulWidget {
  const ImageApiDataPage({super.key});

  @override
  State<ImageApiDataPage> createState() => _ImageApiDataPageState();
}

class _ImageApiDataPageState extends State<ImageApiDataPage> {
  late Future<List<ImageDataApiModel>> ImageDataApiList;

  Future<List<ImageDataApiModel>> imageDataApi()async{
    final urlResponse = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    if(urlResponse.statusCode==200){
      List dataResponse = jsonDecode(urlResponse.body);
      return dataResponse.map((e) => ImageDataApiModel.fromJson(e)).toList();
    }else{
      throw Exception("No Data Found");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ImageDataApiList=imageDataApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Data Api"),centerTitle: true,),
      body: Container(
        child: FutureBuilder<List<ImageDataApiModel>>(
          future: ImageDataApiList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Some Error ${snapshot.hasError}");
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return const Text("No Data Found");
            }else{
              return ListView.builder(itemBuilder: (context,index){
                return Container(
                  child: Column(
                    children: [
                      Text("Albem Id ${snapshot.data![index].albumId}"),
                      Text(" Id ${snapshot.data![index].id}"),
                      SizedBox(
                        height: 80,width: 80,
                          child: CachedNetworkImage(
                          imageUrl:snapshot.data![index].thumbnailUrl.toString() ,
                            placeholder: (context,url)=>const CircularProgressIndicator(),
                          errorWidget: (context,url,error)=>const Icon(Icons.error),)

                  ),
                  ]
                )
                );
              });
            }
          },
        ),
      ),
    );
  }
}
class ImageDataApiModel{
  final int? albumId;
  final int? id;
  final String? url;
  final String? thumbnailUrl;
  ImageDataApiModel({required this.albumId,required this.id,required this.url,required this.thumbnailUrl});
  factory ImageDataApiModel.fromJson(Map<String,dynamic>json){
    return ImageDataApiModel(
        albumId: json["albumId"],
        id: json["id"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"]);
  }
}
