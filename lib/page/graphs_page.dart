import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/sensor_model.dart';

class GraphsPage extends StatelessWidget {
  final List<Sensor> sensors;

  const GraphsPage({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Graphs"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: sensors.map((sensor) => buildGraph(sensor)).toList(),
      ),
    );
  }

  Widget buildGraph(Sensor sensor) {
    if (sensor.history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No data available"),
      );
    }

    // Extract min & max values
    final values = sensor.history.map((d) => d.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    // Add ±10 buffer
    final yMin = minValue - 10;
    final yMax = maxValue + 10;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(
          minimum: yMin < 0 ? 0 : yMin, // avoid negative values if not needed
          maximum: yMax,
        ),
        title: ChartTitle(text: "${sensor.name} (Last 24 hours)"),
        series: <CartesianSeries<GraphData, DateTime>>[
          LineSeries<GraphData, DateTime>(
            dataSource: sensor.history,
            xValueMapper: (GraphData d, _) => d.time,
            yValueMapper: (GraphData d, _) => d.value,
            markerSettings: const MarkerSettings(isVisible: true), // nice dots
          )
        ],
      ),
    );
  }
}
