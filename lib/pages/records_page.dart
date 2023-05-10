import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugogram/models/bpm_record.dart';
import 'package:tugogram/models/database_helper.dart';

class BpmRecordsPage extends StatelessWidget {
  const BpmRecordsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<BpmRecord>>(
        future: DatabaseHelper().getBpmRecords(),
        builder: (BuildContext context, AsyncSnapshot<List<BpmRecord>> snapshot) {
          if (snapshot.hasData) {
            final bpmRecords = snapshot.data!;
            if (bpmRecords.isEmpty) {
              return const Center(
                child: Text(
                  'There are no records',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: bpmRecords.length,
              itemBuilder: (BuildContext context, int index) {
                final bpmRecord = bpmRecords[index];
                return Dismissible(
                  key: Key(bpmRecord.id.toString()),
                  onDismissed: (_) async {
                    await DatabaseHelper().deleteBpmRecord(bpmRecord.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('BPM record deleted.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text('${bpmRecord.bpm} BPM'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('MMM d, yyyy hh:mm a').format(bpmRecord.time)),
                        if (bpmRecord.notes.isNotEmpty) Text(bpmRecord.notes),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
