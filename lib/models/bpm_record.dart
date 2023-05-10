class BpmRecord {
  final int? id;
  final int bpm;
  final DateTime time;
  final String notes;

  BpmRecord({
    this.id,
    required this.bpm,
    required this.time,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bpm': bpm,
      'time': time.millisecondsSinceEpoch,
      'notes': notes,
    };
  }

  static BpmRecord fromMap(Map<String, dynamic> map) {
    return BpmRecord(
      id: map['id'] as int,
      bpm: map['bpm'] as int,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      notes: map['notes'] as String,
    );
  }
}
