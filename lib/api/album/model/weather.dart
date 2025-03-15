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
  final CurrentUnits? currentUnits;
  final Current? current;
  final HourlyUnits? hourlyUnits;
  final Hourly? hourly;
  final DailyUnits? dailyUnits;
  final Daily? daily;

  Welcome({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentUnits,
    this.current,
    this.hourlyUnits,
    this.hourly,
    this.dailyUnits,
    this.daily,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    generationtimeMs: json["generationtime_ms"]?.toDouble(),
    utcOffsetSeconds: json["utc_offset_seconds"],
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    elevation: json["elevation"],
    currentUnits:
        json["current_units"] == null
            ? null
            : CurrentUnits.fromJson(json["current_units"]),
    current: json["current"] == null ? null : Current.fromJson(json["current"]),
    hourlyUnits:
        json["hourly_units"] == null
            ? null
            : HourlyUnits.fromJson(json["hourly_units"]),
    hourly: json["hourly"] == null ? null : Hourly.fromJson(json["hourly"]),
    dailyUnits:
        json["daily_units"] == null
            ? null
            : DailyUnits.fromJson(json["daily_units"]),
    daily: json["daily"] == null ? null : Daily.fromJson(json["daily"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "current_units": currentUnits?.toJson(),
    "current": current?.toJson(),
    "hourly_units": hourlyUnits?.toJson(),
    "hourly": hourly?.toJson(),
    "daily_units": dailyUnits?.toJson(),
    "daily": daily?.toJson(),
  };
}

class Current {
  final String? time;
  final int? interval;
  final double? surfacePressure;

  Current({this.time, this.interval, this.surfacePressure});

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    time: json["time"],
    interval: json["interval"],
    surfacePressure: json["surface_pressure"]?.toDouble() ?? 1013.25,
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "surface_pressure": surfacePressure,
  };
}

class CurrentUnits {
  final String? time;
  final String? interval;
  final String? surfacePressure;

  CurrentUnits({this.time, this.interval, this.surfacePressure});

  factory CurrentUnits.fromJson(Map<String, dynamic> json) => CurrentUnits(
    time: json["time"],
    interval: json["interval"],
    surfacePressure: json["surface_pressure"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "surface_pressure": surfacePressure,
  };
}

class Daily {
  final List<DateTime>? time;
  final List<double>? uvIndexMax;
  final List<int>? precipitationProbabilityMax;

  Daily({this.time, this.uvIndexMax, this.precipitationProbabilityMax});

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
    time:
        json["time"] == null
            ? []
            : List<DateTime>.from(json["time"]!.map((x) => DateTime.parse(x))),
    uvIndexMax:
        json["uv_index_max"] == null
            ? []
            : List<double>.from(
              json["uv_index_max"]!.map((x) => x?.toDouble()),
            ),
    precipitationProbabilityMax:
        json["precipitation_probability_max"] == null
            ? []
            : List<int>.from(
              json["precipitation_probability_max"]!.map((x) => x),
            ),
  );

  Map<String, dynamic> toJson() => {
    "time":
        time == null
            ? []
            : List<dynamic>.from(
              time!.map(
                (x) =>
                    "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}",
              ),
            ),
    "uv_index_max":
        uvIndexMax == null ? [] : List<dynamic>.from(uvIndexMax!.map((x) => x)),
    "precipitation_probability_max":
        precipitationProbabilityMax == null
            ? []
            : List<dynamic>.from(precipitationProbabilityMax!.map((x) => x)),
  };
}

class DailyUnits {
  final String? time;
  final String? uvIndexMax;
  final String? precipitationProbabilityMax;

  DailyUnits({this.time, this.uvIndexMax, this.precipitationProbabilityMax});

  factory DailyUnits.fromJson(Map<String, dynamic> json) => DailyUnits(
    time: json["time"],
    uvIndexMax: json["uv_index_max"],
    precipitationProbabilityMax: json["precipitation_probability_max"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "uv_index_max": uvIndexMax,
    "precipitation_probability_max": precipitationProbabilityMax,
  };
}

class Hourly {
  final List<String>? time;
  final List<double>? dewPoint2M;
  final List<int>? rain;
  final List<int>? precipitationProbability;
  final List<double>? temperature80M;
  final List<double>? windSpeed80M;
  final List<double>? temperature2M;

  Hourly({
    this.time,
    this.dewPoint2M,
    this.rain,
    this.precipitationProbability,
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
        json["rain"] == null ? [] : List<int>.from(json["rain"]!.map((x) => x)),
    precipitationProbability:
        json["precipitation_probability"] == null
            ? []
            : List<int>.from(json["precipitation_probability"]!.map((x) => x)),
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
  final String? temperature80M;
  final String? windSpeed80M;
  final String? temperature2M;

  HourlyUnits({
    this.time,
    this.dewPoint2M,
    this.rain,
    this.precipitationProbability,
    this.temperature80M,
    this.windSpeed80M,
    this.temperature2M,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    dewPoint2M: json["dew_point_2m"],
    rain: json["rain"],
    precipitationProbability: json["precipitation_probability"],
    temperature80M: json["temperature_80m"],
    windSpeed80M: json["wind_speed_80m"],
    temperature2M: json["temperature_2m"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "dew_point_2m": dewPoint2M,
    "rain": rain,
    "precipitation_probability": precipitationProbability,
    "temperature_80m": temperature80M,
    "wind_speed_80m": windSpeed80M,
    "temperature_2m": temperature2M,
  };
}
