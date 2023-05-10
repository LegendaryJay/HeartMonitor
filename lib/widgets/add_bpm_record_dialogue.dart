import 'package:flutter/material.dart';

class AddBpmRecordDialog extends StatefulWidget {
  const AddBpmRecordDialog({Key? key}) : super(key: key);

  @override
  _AddBpmRecordDialogState createState() => _AddBpmRecordDialogState();
}

class _AddBpmRecordDialogState extends State<AddBpmRecordDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  int _bpm = 0;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add BPM Record'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textEditingController,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'BPM',
            ),
            onChanged: (value) {
              setState(() {
                _bpm = int.tryParse(value) ?? 0;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _bpm > 0 ? () {
            Navigator.of(context).pop(_bpm);
          } : null,
          child: const Text('ADD'),
        ),
      ],
    );
  }
}