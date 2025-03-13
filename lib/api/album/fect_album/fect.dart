import 'dart:convert';

import 'package:api_weather/api/album/model/album.dart';
import 'package:api_weather/api/album/model/weather.dart';
import 'package:api_weather/api/repo.dart';
import 'package:http/http.dart' as http;

Future<Welcome> fetchWeather() async {
  final response = await fetchWeatherAPI();
  print(response);
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Welcome.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load weather');
  }
}
