import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const apiKey = 'a45d6c6adba01aaa6b7a0844aaa28a32'; // ключ

class Weather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WeatherState();
  }
}

class WeatherState extends State<Weather> {
  String city = 'Almaty';
  String temperature = '';
  String weatherIcon = '';
  List<dynamic> hourlyForecast = [];

  final List<String> cities = [
    'Almaty',
    'Astana',
    'Shymkent',
    'Aktobe',
    'Zharkent',
    'Atyrau',
    'Karaganda',
    'Koktal',
    'Oskemen',
    'Kokshetau',
    'Kostanay',
    'Saryozek',
    'Atbasar',
    'Taldykorgan',
    'New York City',
    'Kyiv',
  ];

  Future<void> fetchWeatherData() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);

      setState(() {
        temperature = data['main']['temp'] != null
            ? data['main']['temp'].toStringAsFixed(1)
            : '';
        weatherIcon = data['weather'][0]['icon'] ?? '';
      });
    }
  }

  Future<void> fetchHourlyForecastData() async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);

      setState(() {
        hourlyForecast = data['list'] ?? [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
    fetchHourlyForecastData();
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
        width: double.infinity,
      ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      DropdownButton<String>(
        value: city,
        onChanged: (value) {
          setState(() {
            city = value!;
          });
          fetchWeatherData();
          fetchHourlyForecastData();

        },
        items: cities
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20, // Set font size to 20
                color: Colors.white, // Set text color to white
              ),
            ),
          );
        }).toList(),
        style: const TextStyle(color: Colors.deepPurpleAccent),
        dropdownColor: Colors.blue, // Set dropdown background color to black
        underline: Container(
          height: 2, // Set underline height to 2
          color: Colors.white, // Set underline color to white
        ),
        iconEnabledColor: Colors.white, // Set dropdown icon color to white
      ),

      const SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    '$temperature °C',
    style: const TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(width: 16),
    if (weatherIcon.isNotEmpty)
    Image.network(
    'https://openweathermap.org/img/w/$weatherIcon.png',
    width: 80,
    height: 80,
    ),
    ],
    ),
    const SizedBox(height: 32),
      Expanded(
        child: hourlyForecast.isNotEmpty
            ? ListView.builder(
          itemCount: hourlyForecast.length,
          itemBuilder: (context, index) {
            final item = hourlyForecast[index];
            final dateTime = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
            final time = TimeOfDay.fromDateTime(dateTime);
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${time.format(context)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (item['weather'] != null && item['weather'].isNotEmpty)
                      Image.network(
                        'https://openweathermap.org/img/w/${item['weather'][0]['icon']}.png',
                        width: 40,
                        height: 40,
                      ),
                    const SizedBox(width: 16),
                    Text(
                      '${item['main']['temp']} °C',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      ),

    ],
    ),
    ),
      ],
    );
  }
}