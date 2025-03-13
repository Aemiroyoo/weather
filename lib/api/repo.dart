import 'package:api_weather/api/endpoint.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchWeatherAPI() {
  print(
    '${Endpoint.baseUrl}forecast?latitude=-6.2&longitude=106.816666&hourly=dew_point_2m,rain,precipitation_probability,showers,temperature_80m,wind_speed_80m,temperature_2m&timezone=Asia%2FBangkok',
  );
  return http.get(
    Uri.parse(
      '${Endpoint.baseUrl}forecast?latitude=-6.2&longitude=106.816666&hourly=dew_point_2m,rain,precipitation_probability,showers,temperature_80m,wind_speed_80m,temperature_2m&timezone=Asia%2FBangkok',
    ),
  );
}
