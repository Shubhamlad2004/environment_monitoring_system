class Sensor {
  final String name;
  final double value;
  final double maxValue;
  final List<GraphData> history;

  Sensor({
    required this.name,
    required this.value,
    required this.maxValue,
    required this.history,
  });
}

class GraphData {
  final DateTime time;
  final double value;

  GraphData({required this.time, required this.value});
}
