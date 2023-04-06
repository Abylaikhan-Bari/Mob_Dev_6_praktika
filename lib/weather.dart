import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
const apiKey = '';//ключ
class Weather extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return WeatherState();
  }

}
class WeatherState extends State<Weather>{
  String city = 'Almaty';
  String temperature = '';
  String weatherIcon = '';
  //разберите данный метод
  Future<void> fetchWeatherData() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);

      setState(() {
        temperature = data['main']['temp'].toStringAsFixed(1);
        weatherIcon = data['weather'][0]['icon'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          height: 1050,
          child: Image(
            image: AssetImage('assets/images/sky.png'),
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) => city = value,
                style: const TextStyle(color: Colors.green),
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: fetchWeatherData,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    city,
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                  ),

                  weatherIcon.isEmpty
                      ? CircularProgressIndicator()
                      : Image.network(
                    'https://openweathermap.org/img/w/$weatherIcon.png',
                    height: 100.0,
                    width: 100.0,
                  ),
                  Text(
                    '$temperature°C',
                    style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                ],)


            ],
          ),
        )

      ],
    );
  }

}
