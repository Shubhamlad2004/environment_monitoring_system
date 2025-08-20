import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/sensor_model.dart';
import 'page/home.dart';

Future<void> main() async {
  await dotenv.load(fileName: "lib/assets/.env"); 
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Sensor> sensors = [];
  String lastUpdated = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    final String channelId = dotenv.env['CHANNEL_ID'] ?? "";
    final String apiKey = dotenv.env['API_KEY'] ?? "";

    final String url =
        "https://api.thingspeak.com/channels/$channelId/feeds.json?api_key=$apiKey&results=50";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final feeds = data['feeds'] as List;

        final latest = feeds.last;

        setState(() {
          lastUpdated = latest['created_at'];

          sensors = [
            Sensor(
              name: "Temperature",
              value: double.tryParse(latest['field1'] ?? "0") ?? 0,
              maxValue: 50,
              history: feeds
                  .map((f) => GraphData(
                        time: DateTime.parse(f['created_at']),
                        value: double.tryParse(f['field1'] ?? "0") ?? 0,
                      ))
                  .toList(),
            ),
            Sensor(
              name: "Humidity",
              value: double.tryParse(latest['field2'] ?? "0") ?? 0,
              maxValue: 100,
              history: feeds
                  .map((f) => GraphData(
                        time: DateTime.parse(f['created_at']),
                        value: double.tryParse(f['field2'] ?? "0") ?? 0,
                      ))
                  .toList(),
            ),
            Sensor(
              name: "Air Quality",
              value: double.tryParse(latest['field3'] ?? "0") ?? 0,
              maxValue: 500,
              history: feeds
                  .map((f) => GraphData(
                        time: DateTime.parse(f['created_at']),
                        value: double.tryParse(f['field3'] ?? "0") ?? 0,
                      ))
                  .toList(),
            ),
            Sensor(
              name: "Pressure",
              value: double.tryParse(latest['field4'] ?? "0") ?? 0,
              maxValue: 1100,
              history: feeds
                  .map((f) => GraphData(
                        time: DateTime.parse(f['created_at']),
                        value: double.tryParse(f['field4'] ?? "0") ?? 0,
                      ))
                  .toList(),
            ),
          ];
        });
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        sensors: sensors,
        lastUpdated: lastUpdated,
        onRefresh: fetchData,
        isLoading: isLoading,
      ),
    );
  }
}
