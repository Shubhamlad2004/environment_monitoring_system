import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'graphs_page.dart'; // new page
import '../models/sensor_model.dart'; // if we separated Sensor & GraphData models

class MyHomePage extends StatelessWidget {
  final List<Sensor> sensors;
  final String lastUpdated;
  final VoidCallback onRefresh;
  final bool isLoading;

  const MyHomePage({
    super.key,
    required this.sensors,
    required this.lastUpdated,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Environment Monitoring"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Last updated: $lastUpdated",
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: sensors.map((sensor) => buildGauge(sensor)).toList(),
          ),
        ],
      ),

      // ✅ Button at bottom to go to Graphs
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GraphsPage(sensors: sensors),
            ),
          );
        },
        label: const Text("View Graphs"),
        icon: const Icon(Icons.show_chart),
      ),
    );
  }

  Widget buildGauge(Sensor sensor) {
    return Column(
      children: [
        Text(sensor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          width: 150,
          height: 150,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: sensor.maxValue,
                pointers: <GaugePointer>[
                  NeedlePointer(value: sensor.value),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      sensor.value.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    angle: 90,
                    positionFactor: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
