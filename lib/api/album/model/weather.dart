// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  final double? latitude;
  final double? longitude;
  final double? generationtimeMs;
  final int? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final int? elevation;
  final HourlyUnits? hourlyUnits;
  final Hourly? hourly;

  Welcome({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.hourlyUnits,
    this.hourly,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    generationtimeMs: json["generationtime_ms"]?.toDouble(),
    // utcOffsetSeconds: json["utc_offset_seconds"],
    utcOffsetSeconds: (json["utc_offset_seconds"] as num?)?.toInt(),
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    // elevation: json["elevation"],
    elevation: (json["elevation"] as num?)?.toInt(),

    hourlyUnits:
        json["hourly_units"] == null
            ? null
            : HourlyUnits.fromJson(json["hourly_units"]),
    hourly: json["hourly"] == null ? null : Hourly.fromJson(json["hourly"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "hourly_units": hourlyUnits?.toJson(),
    "hourly": hourly?.toJson(),
  };
}

class Hourly {
  final List<String>? time;
  final List<double>? dewPoint2M;
  final List<double>? rain;
  final List<int>? precipitationProbability;
  final List<double>? showers;
  final List<double>? temperature80M;
  final List<double>? windSpeed80M;
  final List<double>? temperature2M;

  Hourly({
    this.time,
    this.dewPoint2M,
    this.rain,
    this.precipitationProbability,
    this.showers,
    this.temperature80M,
    this.windSpeed80M,
    this.temperature2M,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time:
        json["time"] == null
            ? []
            : List<String>.from(json["time"]!.map((x) => x)),
    dewPoint2M:
        json["dew_point_2m"] == null
            ? []
            : List<double>.from(
              json["dew_point_2m"]!.map((x) => x?.toDouble()),
            ),
    rain:
        json["rain"] == null
            ? []
            : List<double>.from(json["rain"]!.map((x) => x?.toDouble())),
    precipitationProbability:
        json["precipitation_probability"] == null
            ? []
            : List<int>.from(json["precipitation_probability"]!.map((x) => x)),
    showers:
        json["showers"] == null
            ? []
            : List<double>.from(json["showers"]!.map((x) => x?.toDouble())),
    temperature80M:
        json["temperature_80m"] == null
            ? []
            : List<double>.from(
              json["temperature_80m"]!.map((x) => x?.toDouble()),
            ),
    windSpeed80M:
        json["wind_speed_80m"] == null
            ? []
            : List<double>.from(
              json["wind_speed_80m"]!.map((x) => x?.toDouble()),
            ),
    temperature2M:
        json["temperature_2m"] == null
            ? []
            : List<double>.from(
              json["temperature_2m"]!.map((x) => x?.toDouble()),
            ),
  );

  Map<String, dynamic> toJson() => {
    "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
    "dew_point_2m":
        dewPoint2M == null ? [] : List<dynamic>.from(dewPoint2M!.map((x) => x)),
    "rain": rain == null ? [] : List<dynamic>.from(rain!.map((x) => x)),
    "precipitation_probability":
        precipitationProbability == null
            ? []
            : List<dynamic>.from(precipitationProbability!.map((x) => x)),
    "showers":
        showers == null ? [] : List<dynamic>.from(showers!.map((x) => x)),
    "temperature_80m":
        temperature80M == null
            ? []
            : List<dynamic>.from(temperature80M!.map((x) => x)),
    "wind_speed_80m":
        windSpeed80M == null
            ? []
            : List<dynamic>.from(windSpeed80M!.map((x) => x)),
    "temperature_2m":
        temperature2M == null
            ? []
            : List<dynamic>.from(temperature2M!.map((x) => x)),
  };
}

class HourlyUnits {
  final String? time;
  final String? dewPoint2M;
  final String? rain;
  final String? precipitationProbability;
  final String? showers;
  final String? temperature80M;
  final String? windSpeed80M;
  final String? temperature2M;

  HourlyUnits({
    this.time,
    this.dewPoint2M,
    this.rain,
    this.precipitationProbability,
    this.showers,
    this.temperature80M,
    this.windSpeed80M,
    this.temperature2M,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    dewPoint2M: json["dew_point_2m"],
    rain: json["rain"],
    precipitationProbability: json["precipitation_probability"],
    showers: json["showers"],
    temperature80M: json["temperature_80m"],
    windSpeed80M: json["wind_speed_80m"],
    temperature2M: json["temperature_2m"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "dew_point_2m": dewPoint2M,
    "rain": rain,
    "precipitation_probability": precipitationProbability,
    "showers": showers,
    "temperature_80m": temperature80M,
    "wind_speed_80m": windSpeed80M,
    "temperature_2m": temperature2M,
  };
}
