import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = "Ibadan";
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  Future getWeather() async {
    http.Response response = await http.get(
       api(city));
    var result = jsonDecode(response.body);
    setState(() {
      this.temp = result['main']['temp'];
      this.description = result['weather'][0]['description'];
      this.currently = result['weather'][0]['main'];
      this.windSpeed = result['wind']['speed'];
      this.humidity = result['main']['humidity'];
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Currently in $city',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: 10.0),
                  Text(currently != null?'You have a $currently Cloud': "Loading",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            )),
        Expanded(
            flex: 3,
            child: Container(
                child: GridView(
              padding: EdgeInsets.all(15),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                AttributeCard(
                  attribute: temp,
                  title: "Temperature",
                ),
                AttributeCard(
                  attribute: description,
                  title: "Weather",
                ),
                AttributeCard(
                  attribute: humidity,
                  title: "Humidity",
                ),
                AttributeCard(
                  attribute: windSpeed,
                  title: "Wind Speed",
                )
              ],
            ))),
      ],
    ));
  }
}

class AttributeCard extends StatelessWidget {
  const AttributeCard({Key key, @required this.attribute, this.title})
      : super(key: key);

  final attribute;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            height: 20.0,
          ),
          Text(attribute != null ? attribute.toString() : "Loading")
        ],
      ),
    );
  }
}
