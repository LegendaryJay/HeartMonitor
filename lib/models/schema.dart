const String bpmRecordsTable = 'bpm_records';

class BpmRecordFields {
  static const String id = 'id';
  static const String bpm = 'bpm';
  static const String time = 'time';
  static const String notes = 'notes';
}

const String createBpmRecordsTable = '''
  CREATE TABLE $bpmRecordsTable (
    ${BpmRecordFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${BpmRecordFields.bpm} INTEGER NOT NULL,
    ${BpmRecordFields.time} INTEGER NOT NULL,
    ${BpmRecordFields.notes} TEXT NOT NULL
  )
''';
