import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tugogram/models/bpm_record.dart';
import 'package:tugogram/models/bpm_utilies.dart';
import 'package:tugogram/models/database_helper.dart';

class BPMPage extends StatefulWidget {
  const BPMPage({Key? key}) : super(key: key);

  @override
  BPMPageState createState() => BPMPageState();
}

class BPMPageState extends State<BPMPage> {
  final heartRateData = HeartRateData(age: 30);
  late ContextualizedHeartRate hrContext = heartRateData.getContext(0);
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final List<int> timestamps = [];
  final int timeoutTime = 1500;
  Timer? _timer;
  double lastBPM = 0;
  bool saveButtonEnabled = false;
  double reserveHeartRatePercentage = 0;


  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleButtonPress() {
    setState(() {
      saveButtonEnabled = false;
      final now = DateTime.now().millisecondsSinceEpoch;
      while (timestamps.isNotEmpty && (now - timestamps.first) > (timeoutTime * 2)) {
        timestamps.removeAt(0);
      }
      if (timestamps.isNotEmpty) {
        lastBPM = 60000 * timestamps.length / (now - timestamps.first);
        hrContext = heartRateData.getContext(lastBPM.toInt());
        _textEditingController.text = '${lastBPM.toStringAsFixed(0)} BPM | ${hrContext.level}';
      } else {
        _textEditingController.text = 'Tap again!';
      }
      timestamps.add(now);
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: timeoutTime), _handleTimeRunOut);
    });
  }

  Future<void> _handleSaveButtonPress() async {

    final bpmRecord = BpmRecord(
      bpm: lastBPM.toInt(),
      time: DateTime.now(),
      notes: hrContext.level,
    );

    final db = DatabaseHelper();
    await db.insertBpmRecord(bpmRecord);
    setState(() {
      saveButtonEnabled = false;
    });
    _scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('BPM record saved.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTimeRunOut() {
    if (timestamps.length > 1){
      setState(() {
        saveButtonEnabled = true;
        _textEditingController.text = 'Final: ${lastBPM.toStringAsFixed(0)} BPM';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Heart Rate',
                        labelStyle: TextStyle(fontSize: 16, color: themeData.primaryColor),
                      ),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeData.primaryColorDark),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save, size: 30),
                    onPressed: saveButtonEnabled ? _handleSaveButtonPress : null,
                    color: saveButtonEnabled ? themeData.primaryColor : themeData.disabledColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _handleButtonPress,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    primary: themeData.primaryColor,
                    onPrimary: themeData.primaryColorLight,
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Text(
                        'Tap to Measure BPM',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: LinearProgressIndicator(
                value: hrContext.reserveHeartRatePercentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(hrContext.color),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
