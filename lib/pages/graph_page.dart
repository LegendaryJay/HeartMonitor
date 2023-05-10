import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tugogram/models/bpm_record.dart';
import 'package:tugogram/models/database_helper.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late List<BpmRecord> _bpmRecords;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBpmRecords();
  }

  Future<void> _getBpmRecords() async {
    final dbHelper = DatabaseHelper();
    final records = await dbHelper.getBpmRecords();
    setState(() {
      _bpmRecords = records;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: themeData.primaryColor))
          : _buildChart(),
    );
  }

  Widget _buildChart() {
    final data = _bpmRecords.map((record) {
      return BpmData(record.time, record.bpm);
    }).toList();

    final series = [
      charts.Series<BpmData, DateTime>(
        id: 'BPM',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        domainFn: (BpmData bpm, _) => bpm.time,
        measureFn: (BpmData bpm, _) => bpm.bpm,
        data: data,
      )
    ];

    return charts.TimeSeriesChart(
      series,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        charts.ChartTitle('BPM Over Time',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 16, color: charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor))),
        charts.ChartTitle('Time',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 14, color: charts.ColorUtil.fromDartColor(Theme.of(context).primaryColorDark))),
        charts.ChartTitle('BPM',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 14, color: charts.ColorUtil.fromDartColor(Theme.of(context).primaryColorDark))),
      ],
    );
  }

}

class BpmData {
  final DateTime time;
  final int bpm;

  BpmData(this.time, this.bpm);
}
