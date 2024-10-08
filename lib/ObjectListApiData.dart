import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ObjectListApiPage extends StatefulWidget {
  const ObjectListApiPage({super.key});

  @override
  State<ObjectListApiPage> createState() => _ObjectListApiPageState();
}

class _ObjectListApiPageState extends State<ObjectListApiPage> {
  late Future<PriceModel> priceModelList;

  Future<PriceModel> _priceModelApi()async{
    final apiResponse = await http.get(Uri.parse("https://api.coindesk.com/v1/bpi/currentprice.json"));

    if(apiResponse.statusCode==200){
     final Map<String,dynamic> responseData = jsonDecode(apiResponse.body);
      return PriceModel.formJson(responseData);
    }else{
      throw Exception("No data found");
    }
  }
  String formatDateString(String dateStr) {
    // Define the input format
    DateFormat inputFormat;
    if (dateStr.contains('at')) {
      inputFormat = DateFormat("MMM d, yyyy 'at' HH:mm z");
    } else {
      inputFormat = DateFormat("MMM d, yyyy HH:mm:ss 'UTC'");
    }

    DateTime dateTime = inputFormat.parse(dateStr);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return outputFormat.format(dateTime);
  }

  String formatDateStringDif(String dateStr) {

    DateTime dateTime = DateTime.parse(dateStr);
    DateFormat outputFormat = DateFormat("MMM d, yyyy HH:mm:ss");
    return outputFormat.format(dateTime);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceModelList=_priceModelApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Object List Api'),centerTitle: true,),
      body: Container(
        child: FutureBuilder<PriceModel>(
          future: priceModelList,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: LinearProgressIndicator(),);
            }else if(snapshot.hasError){
              return Text("Error Found ${snapshot.hasError}");
            }else if(!snapshot.hasData){
              return const Text("No Data Found");
            }else{
              return Container(
                child: Column(children: [
                  const Text("Time"),
                  Text("Updated :- ${formatDateString(snapshot.data!.time!.updated.toString())}"),
                  Text("Updated ISO :- ${formatDateStringDif(snapshot.data!.time!.updatedISO.toString())}"),
                  Text("Updated DUK :- ${formatDateString(snapshot.data!.time!.updateduk.toString())}"),
                  Text("Disclaimer :- ${snapshot.data!.disclaimer}"),
                  Text("Chart Name :- ${snapshot.data!.chartName}"),
                  const Text("BPI :"),
                  const Text("USD :"),
                  Text("Code :- ${snapshot.data!.bpi!.Usd!.code}"),
                  Text("Symbol :- ${snapshot.data!.bpi!.Usd!.symbol}"),
                  Text("Rate :- ${snapshot.data!.bpi!.Usd!.rate}"),
                  Text("Discription :- ${snapshot.data!.bpi!.Usd!.description}"),
                  Text("Rate Value :- ${snapshot.data!.bpi!.Usd!.rate_float}"),
                  const Text("GBP :"),
                  Text("Code :- ${snapshot.data!.bpi!.Gbp!.code}"),
                  Text("Symbol :- ${snapshot.data!.bpi!.Gbp!.symbol}"),
                  Text("Rate :- ${snapshot.data!.bpi!.Gbp!.rate}"),
                  Text("Discription :- ${snapshot.data!.bpi!.Gbp!.description}"),
                  Text("Rate Value :- ${snapshot.data!.bpi!.Gbp!.rate_float}"),
                  const Text("EUR :"),
                  Text("Code :- ${snapshot.data!.bpi!.Eur!.code}"),
                  Text("Symbol :- ${snapshot.data!.bpi!.Eur!.symbol}"),
                  Text("Rate :- ${snapshot.data!.bpi!.Eur!.rate}"),
                  Text("Discription :- ${snapshot.data!.bpi!.Eur!.description}"),
                  Text("Rate Value :- ${snapshot.data!.bpi!.Eur!.rate_float}"),
                ],),
              );
            }
          },
        ),
      ),
    );
  }
}
class PriceModel{
  final Time? time;
  final String? disclaimer;
  final String? chartName;
  final BPI? bpi;

  PriceModel({required this.time,required this.disclaimer,required this.chartName,required this.bpi});
  factory PriceModel.formJson(Map<String,dynamic>json){
    return PriceModel(
        time: Time.fromJson(json["time"]),
        disclaimer: json["disclaimer"],
        chartName: json["chartName"],
        bpi: BPI.fromJson(json["bpi"]));
  }
}
class Time{
    final String? updated;
    final String? updatedISO;
    final String? updateduk;
    Time({required this.updated,required this.updatedISO,required this.updateduk});
    factory Time.fromJson(Map<String,dynamic>json){
      return Time(
          updated: json["updated"],
          updatedISO: json["updatedISO"],
          updateduk: json["updateduk"]);
    }
}
class BPI{
  final Currency? Usd;
  final Currency? Gbp;
  final Currency? Eur;
  BPI({this.Usd, this.Gbp, this.Eur});
  factory BPI.fromJson(Map<String,dynamic>json){
      return BPI(
          Usd: Currency.fromJson(json["USD"]),
          Gbp: Currency.fromJson(json["GBP"]),
          Eur: Currency.fromJson(json["EUR"]));
  }


}

class Currency{
    final String? code;
    final String? symbol;
    final String? rate;
    final String? description;
    final double? rate_float;
    Currency({ this.code, this.symbol, this.rate, this.description, this.rate_float});
    factory Currency.fromJson(Map<String,dynamic>json){
      return Currency(
          code: json["code"],
          symbol: json["symbol"],
          rate: json["rate"],
          description: json["description"],
          rate_float: json["rate_float"]?.toDouble(),
      );
    }
}