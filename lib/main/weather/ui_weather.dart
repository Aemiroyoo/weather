import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:api_weather/api/album/fect_album/fect.dart';
import 'package:api_weather/api/album/model/weather.dart';
import 'package:api_weather/utils/constant/app.color.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: UiWeather());
//   }
// }

class UiWeather extends StatefulWidget {
  const UiWeather({super.key});

  @override
  State<UiWeather> createState() => _UiWeatherState();
}

class _UiWeatherState extends State<UiWeather> {
  String locationText = "Mendeteksi lokasi...";
  late Future<Welcome?> weatherData;
  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    weatherData = fetchWeather();
  }

  /// 🔹 Periksa Izin Lokasi
  void checkPermission() async {
    bool granted = await requestLocationPermission();
    if (granted) {
      fetchUserLocation();
    } else {
      setState(() {
        locationText = "Akses lokasi tidak diizinkan";
      });
    }
  }

  /// 🔹 Ambil Lokasi Pengguna
  void fetchUserLocation() async {
    try {
      Position position = await getCurrentLocation();
      setState(() {
        locationText = "Lokasi: ${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        locationText = "Gagal mendapatkan lokasi";
      });
    }
  }

  /// 🔹 Minta Izin Lokasi
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// 🔹 Ambil Lokasi dengan Akurasi Tinggi
  Future<Position> getCurrentLocation() async {
    bool isPermissionGranted = await requestLocationPermission();
    if (!isPermissionGranted) {
      throw Exception("Izin lokasi tidak diberikan");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// ✅ Widget untuk Menampilkan Status GPS
  Widget _buildLocationStatus(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Stack(
        children: [
          /// 🔹 Background Image dengan Fallback
          Image.asset(
            'assets/images/6109685.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.blue.shade300);
            },
          ),

          /// 🔹 Overlay Transparan untuk Efek Gelap
          Container(color: Colors.black.withOpacity(0.35)),

          Padding(
            padding: const EdgeInsets.only(top: 55.0),
            child: Center(
              child: Column(
                children: [
                  /// 🔹 Judul Aplikasi
                  const Text(
                    'Jakarta Weather Forecast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  /// 🔹 Status GPS (Hidup atau Tidak)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FutureBuilder<bool>(
                      future: isLocationEnabled(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError ||
                            snapshot.data == false) {
                          return _buildLocationStatus(
                            "Hidupkan layanan lokasi",
                            Icons.cloud_off,
                          );
                        } else {
                          return _buildLocationStatus(
                            "Lokasi Aktif",
                            Icons.location_on,
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 Fetch Data Cuaca dari API
                  FutureBuilder<Welcome>(
                    future: fetchWeather(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return _buildWeatherDisplay(
                          "--",
                          "Tidak ada data",
                          Icons.error_outline,
                        );
                      } else {
                        List<double>? temperatures =
                            snapshot.data?.hourly?.temperature2M;
                        String temperature =
                            (temperatures != null && temperatures.isNotEmpty)
                                ? "${temperatures[0].toInt()}"
                                : "--";
                        String condition =
                            snapshot.data?.timezone ?? "Tidak ada data";
                        IconData weatherIcon = _getWeatherIcon(condition);

                        return _buildWeatherDisplay(
                          temperature,
                          condition,
                          weatherIcon,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 **Kartu Detail Cuaca**
                  WeatherDetailCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Widget untuk Menampilkan Cuaca
  Widget _buildWeatherDisplay(
    String temperature,
    String condition,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              temperature,
              style: TextStyle(
                fontSize: 110.0,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 23.0),
              child: Text(
                "°C",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),

        /// 🔹 Kondisi Cuaca
        Text(
          condition,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),

        const SizedBox(height: 10),

        /// 🔹 Indeks Kualitas Udara (IKU)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco, color: Colors.white, size: 16),
              const SizedBox(width: 5),
              const Text(
                "IKU 31",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 Fungsi untuk Menentukan Ikon Berdasarkan Kondisi Cuaca
  IconData _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains("hujan")) {
      return Icons.beach_access;
    } else if (condition.toLowerCase().contains("berawan")) {
      return Icons.wb_cloudy;
    } else if (condition.toLowerCase().contains("cerah")) {
      return Icons.wb_sunny;
    } else {
      return Icons.device_thermostat;
    }
  }
}

/// ✅ **Widget untuk Detail Cuaca**
class WeatherDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              WeatherDetailItem(title: "Terasa seperti", value: "31°C"),
              WeatherDetailItem(title: "Kelembaban", value: "80%"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              WeatherDetailItem(title: "Peluang hujan", value: "49%"),
              WeatherDetailItem(title: "Tekanan", value: "1010mbar"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              WeatherDetailItem(title: "Kecepatan", value: "18.0km/j"),
              WeatherDetailItem(title: "Indeks UV", value: "0"),
            ],
          ),
        ],
      ),
    );
  }
}

/// ✅ **Widget untuk Menampilkan Detail Cuaca**
class WeatherDetailItem extends StatelessWidget {
  final String title;
  final String value;

  const WeatherDetailItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
