// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captured_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CapturedImageAdapter extends TypeAdapter<CapturedImage> {
  @override
  final int typeId = 0;

  @override
  CapturedImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CapturedImage(
      id: fields[0] as String,
      path: fields[1] as String,
      capturedAt: fields[2] as DateTime,
      isSynced: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CapturedImage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.capturedAt)
      ..writeByte(3)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapturedImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
