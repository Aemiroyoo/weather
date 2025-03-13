import 'package:api_weather/api/album/fect_album/fect.dart';
// import 'package:api_weather/api/album/model/album.dart';
import 'package:api_weather/api/album/model/weather.dart';
import 'package:api_weather/utils/constant/app.color.dart';
// import 'package:first_project/api/album/fect_album/fect.dart';
// import 'package:first_project/api/album/model/album.dart';
// import 'package:first_project/utils/constant/app.color.dart';
import 'package:flutter/material.dart';

class WeatherAppScreen extends StatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  State<WeatherAppScreen> createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends State<WeatherAppScreen> {
  late Future<Welcome> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prakiraan Cuaca Jakarta'),
        backgroundColor: AppColor.secondaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                futureWeather = fetchWeather();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Welcome>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Terjadi kesalahan: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final weather = snapshot.data;
              return ListView.builder(
                itemCount: weather?.hourly?.time?.length ?? 0,
                itemBuilder: (context, index) {
                  final time = weather?.hourly?.time?[index];
                  final dewPoint = weather?.hourly?.dewPoint2M?[index];
                  final rain = weather?.hourly?.rain?[index];
                  final precipitationProbability =
                      weather?.hourly?.precipitationProbability?[index];
                  final showers = weather?.hourly?.showers?[index];
                  final temperature80M =
                      weather?.hourly?.temperature80M?[index];
                  final windSpeed80M = weather?.hourly?.windSpeed80M?[index];
                  final temperature2M =
                      weather?.hourly?.temperature2M?[index]; // Suhu 2m

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Waktu: $time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Titik Embun (2m): ${dewPoint?.toStringAsFixed(1) ?? "-"}°C',
                          ),
                          Text('Hujan: ${rain?.toStringAsFixed(1) ?? "-"} mm'),
                          Text(
                            'Probabilitas Presipitasi: ${precipitationProbability ?? "-"}%',
                          ),
                          Text(
                            'Hujan Deras: ${showers?.toStringAsFixed(1) ?? "-"} mm',
                          ),
                          Text(
                            'Suhu (80m): ${temperature80M?.toStringAsFixed(1) ?? "-"}°C',
                          ),
                          Text(
                            'Kecepatan Angin (80m): ${windSpeed80M?.toStringAsFixed(1) ?? "-"} m/s',
                          ),
                          Text(
                            'Suhu (2m): ${temperature2M?.toStringAsFixed(1) ?? "-"}°C',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Text('Tidak ada data tersedia.');
            }

            // By default, show a loading spinner.
            // return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
