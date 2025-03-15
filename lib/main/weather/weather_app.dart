import 'package:flutter/material.dart';
import 'package:api_weather/api/album/fect_album/fect.dart';
import 'package:api_weather/api/album/model/weather.dart';
import 'package:api_weather/utils/constant/app.color.dart';

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
    return DefaultTabController(
      length: 3, // 3 Tab untuk Current, Hourly, dan Daily
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prakiraan Cuaca'),
          backgroundColor: AppColor.secondaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Saat Ini"),
              Tab(text: "Per Jam"),
              Tab(text: "Harian"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  futureWeather = fetchWeather();
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<Welcome>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final weather = snapshot.data!;
              return TabBarView(
                children: [
                  _buildCurrentWeather(weather),
                  _buildHourlyWeather(weather),
                  _buildDailyWeather(weather),
                ],
              );
            } else {
              return const Center(child: Text('Tidak ada data tersedia.'));
            }
          },
        ),
      ),
    );
  }

  /// Widget untuk menampilkan cuaca saat ini
  Widget _buildCurrentWeather(Welcome weather) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Zona Waktu: ${weather.timezone}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text("Koordinat: ${weather.latitude}, ${weather.longitude}"),
          Text("Ketinggian: ${weather.elevation} meter"),
          Text(
            "Tekanan Permukaan: ${weather.current?.surfacePressure?.toStringAsFixed(1) ?? '-'} hPa",
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan perkiraan cuaca per jam
  Widget _buildHourlyWeather(Welcome weather) {
    return ListView.builder(
      itemCount: weather.hourly?.time?.length ?? 0,
      itemBuilder: (context, index) {
        return _buildWeatherCard(
          title: "Jam: ${weather.hourly?.time?[index] ?? '-'}",
          data: [
            "Titik Embun: ${weather.hourly?.dewPoint2M?[index]?.toStringAsFixed(1) ?? '-'}°C",
            "Hujan: ${weather.hourly?.rain?[index]?.toStringAsFixed(1) ?? '-'} mm",
            "Probabilitas Presipitasi: ${weather.hourly?.precipitationProbability?[index] ?? '-'}%",
            "Suhu (80m): ${weather.hourly?.temperature80M?[index]?.toStringAsFixed(1) ?? '-'}°C",
            "Kecepatan Angin (80m): ${weather.hourly?.windSpeed80M?[index]?.toStringAsFixed(1) ?? '-'} m/s",
            "Suhu (2m): ${weather.hourly?.temperature2M?[index]?.toStringAsFixed(1) ?? '-'}°C",
          ],
        );
      },
    );
  }

  /// Widget untuk menampilkan perkiraan cuaca harian
  Widget _buildDailyWeather(Welcome weather) {
    return ListView.builder(
      itemCount: weather.daily?.time?.length ?? 0,
      itemBuilder: (context, index) {
        return _buildWeatherCard(
          title:
              "Tanggal: ${weather.daily?.time?[index]?.toLocal().toString().split(' ')[0] ?? '-'}",
          data: [
            "Indeks UV Maks: ${weather.daily?.uvIndexMax?[index]?.toStringAsFixed(1) ?? '-'}",
            "Probabilitas Presipitasi: ${weather.daily?.precipitationProbabilityMax?[index] ?? '-'}%",
          ],
        );
      },
    );
  }

  /// Widget untuk membuat kartu informasi cuaca
  Widget _buildWeatherCard({
    required String title,
    required List<String> data,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ...data.map((text) => Text(text)).toList(),
          ],
        ),
      ),
    );
  }
}
