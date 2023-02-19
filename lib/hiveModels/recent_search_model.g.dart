// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_search_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentSearchAdapter extends TypeAdapter<RecentSearch> {
  @override
  final int typeId = 0;

  @override
  RecentSearch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSearch(
      hashtag: fields[0] as String,
      weddingName: fields[1] as String,
      weddingDate: fields[2] as String,
      marriageId: fields[3] as String,
      searchTime: fields[4] as DateTime,
      weddingLogo: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecentSearch obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.hashtag)
      ..writeByte(1)
      ..write(obj.weddingName)
      ..writeByte(2)
      ..write(obj.weddingDate)
      ..writeByte(3)
      ..write(obj.marriageId)
      ..writeByte(4)
      ..write(obj.searchTime)
      ..writeByte(5)
      ..write(obj.weddingLogo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
