import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var name;
  var weatherstate;
  var temp;
  double tempc= 0.00;
  double latitude = 0.5;
  double longitude = 0.5;

  @override
  void initState() {
    super.initState();
    getdata();
  }


  getlocation() async {

    Position _currentPosition;
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        forceAndroidLocationManager: true
    );
    latitude = _currentPosition.latitude;
    longitude = _currentPosition.longitude;
    print(latitude);
    print(longitude);
  }

    void getdata() async {
      await getlocation();
      http.Response response = await http.get(Uri.parse(
          "https://community-open-weather-map.p.rapidapi.com/find?lat=$latitude&lon=$longitude"),
          headers: {
            "x-rapidapi-key": "2451971bd7msh72b10ad562f343fp1c591bjsn3cc1de79ab05",
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com"
          });
      Map user = jsonDecode(response.body);
 setState(() {
   name= user['list'][0]['name'];
   weatherstate = user['list'][0]['weather'][0]['description'];
   temp = user['list'][0]['main']['temp'];
   temp = temp-273.15;


 });



      print(temp);
    }


    @override
    Widget build(BuildContext context) {
      return MaterialApp(
          home: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                    title: Text("Location")),
                body: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/bg.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton.icon(onPressed: () {
                            getdata();
                          },
                              icon: Icon(Icons.edit_location),
                              label: Text("Edit location")),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("City: $name",style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                ),
                                Text("Weather: $weatherstate"),
                                Text("Temperature: $temp C"),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              )
          ));
    }
  }


