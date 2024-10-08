import 'package:alltype_apidata/ADVapiUserName.dart';
import 'package:alltype_apidata/ADVnestedArray.dart';
import 'package:alltype_apidata/ListImageDataApi.dart';
import 'package:alltype_apidata/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ADVUdata.dart';
import 'ApiNestedArrey.dart';
import 'ArrayListApi.dart';
import 'ArreyApiPage.dart';
import 'ListAndObjectApi.dart';
import 'LoginPage.dart';
import 'NastedArrayApi.dart';
import 'NestedArrayDemoApi.dart';
import 'NestedTwoList.dart';
import 'ObjectListApiData.dart';
import 'TwoListDataApi.dart';
import 'UserdataApiPage.dart';
import 'imageApiDataApi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showSnackbarLogout() {
    final snackBar = SnackBar(
      content: Text("Are you Sure You want to Log out?",style: TextStyle(fontSize: 12),),
      action: SnackBarAction(

        label: 'Undo',backgroundColor: Colors.green,

        onPressed: () {
          // Perform some action when the user taps "Undo".
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    void _showSnackbarLogout() {
      final snackBar = SnackBar(
        content: Text("Are you Sure You want to Log out?",style: TextStyle(fontSize: 12),),
        action: SnackBarAction(

          label: 'Yes',backgroundColor: Colors.green,

          onPressed: ()async {
            // Perform some action when the user taps "Undo".
            var sharedData = await SharedPreferences.getInstance();
            sharedData.setBool(MyHomePageState.KeyData, false);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LogInPage()));
            setState(() {

            });
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Home Page"),
        actions: [


          IconButton(
              onPressed: (){
            _showSnackbarLogout();

        }, icon: Icon(Icons.logout))],
      ),
      body: Center(

        child: SingleChildScrollView(
          child: Column(
          
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const NestedArrayDemo()));}, child: const Text("Nested Array Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ArrayApiPage()));}, child: const Text("Array Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserdataApiPage()));}, child: const Text("User Data Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ImageApiDataPage()));}, child: const Text("Image Data Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const NestedArryDemoApiPage()));}, child: const Text("Nested Array Data Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ObjectListApiPage()));}, child: const Text("Object List Data Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const NestedArrayApi()));}, child: const Text("List View")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ArrayListApiPage()));}, child: const Text("Array List View")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListAndObjectApiPage()));}, child: const Text("List And Object")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const TowListDataApiPage()));}, child: const Text("Two List Data")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const ImageDataApiPage()));}, child: const Text("List Image Data Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdvUserDataApiPage()));}, child: const Text("Adv User Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdvUdata()));}, child: const Text("Adv User2 Api")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdvNestedArray()));}, child: const Text("Adv Emp Data")),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const NestedTowListPage()));}, child: const Text("Two Nested List Api")),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
