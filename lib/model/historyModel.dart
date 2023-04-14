final String tableName = 'history';

class HistoryField {
  static final String id = '_id';
  static final String date = 'date';
  static final String hour = 'hour';
  static final String meters = 'meters';
}

class History {
  final int? id;
  final String date;
  final int hour;
  final double meters;

  History(
      {this.id, required this.date, required this.hour, required this.meters});

  Map<String, Object?> toJson() => {
        HistoryField.id: id,
        HistoryField.date: date,
        HistoryField.hour: hour,
        HistoryField.meters: meters
      };

  History copy({int? id, String? date, int? hour, double? meters}) =>
      History(
          id: id ?? this.id,
          date: date  ?? this.date,
          hour: hour?? this.hour,
          meters: meters ?? this.meters
          );

  static History fromJson(Map<String, Object?> json) => History(
      id: json[HistoryField.id] as int?,
      date: json[HistoryField.date] as String,
      hour: json[HistoryField.hour] as int,
      meters: double.parse(json[HistoryField.meters].toString()) as double
      );
}
