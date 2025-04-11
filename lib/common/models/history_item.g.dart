// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryItemAdapter extends TypeAdapter<HistoryItem> {
  @override
  final int typeId = 0;

  @override
  HistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryItem(
      unixTime: fields[0] as int,
      contents: fields[1] as String,
      format: fields[2] as String,
      type: fields[3] as String,
      errorLevel: fields[4] as String,
      origin: fields[5] as String,
      isFavorite: fields[6] as bool,
      notes: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.unixTime)
      ..writeByte(1)
      ..write(obj.contents)
      ..writeByte(2)
      ..write(obj.format)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.errorLevel)
      ..writeByte(5)
      ..write(obj.origin)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
