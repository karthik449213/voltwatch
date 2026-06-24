// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BatteryLogAdapter extends TypeAdapter<BatteryLog> {
  @override
  final int typeId = 0;

  @override
  BatteryLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BatteryLog(
      batteryLevel: fields[0] as int,
      batteryState: fields[1] as String,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BatteryLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.batteryLevel)
      ..writeByte(1)
      ..write(obj.batteryState)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatteryLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
