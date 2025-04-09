import 'package:hive/hive.dart';
part 'history_item.g.dart';

@HiveType(typeId: 0)
class HistoryItem extends HiveObject {
  @HiveField(0)
  int unixTime;

  @HiveField(1)
  String contents;

  @HiveField(2)
  String formatName;

  @HiveField(3)
  String type;

  @HiveField(4)
  String errorCorrectionLevel;

  @HiveField(5)
  String origin;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  String notes;

  HistoryItem({
    required this.unixTime,
    required this.contents,
    required this.formatName,
    required this.type,
    required this.errorCorrectionLevel,
    required this.origin,
    required this.isFavorite,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'unixTime': unixTime,
      'contents': contents,
      'formatName': formatName,
      'type': type,
      'errorCorrectionLevel': errorCorrectionLevel,
      'origin': origin,
      'isFavorite': isFavorite,
      'notes': notes,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      unixTime: json['unixTime'] ?? 0,
      contents: json['contents'] ?? 'Error: No data',
      formatName: json['formatName'] ?? 'NONE',
      type: json['type'] ?? 'NONE',
      errorCorrectionLevel: json['errorCorrectionLevel'] ?? 'NONE',
      origin: json['origin'] ?? 'C',
      isFavorite: json['isFavorite'] ?? false,
      notes: json['notes'] ?? '',
    );
  }

}
