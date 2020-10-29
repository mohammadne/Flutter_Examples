import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehicle.g.dart';

abstract class Vehicle implements Built<Vehicle, VehicleBuilder> {
  Vehicle._();

  VehicleType get type;

  String get name;

  @nullable
  String get price;

  BuiltList passengers;

  factory Vehicle([updated(VehicleBuilder b)]) = _$Vehicle;

  static Serializer<Vehicle> get serializer => _$vehicleSerializer;

  String toJson() => serializer.serializerWith(Vehicle.serializer, this);

  static Vehicle fromJson(String jsonStr) =>
      serializer.deserializerWith(Vehicle.serializer, json.decode(jsonStr));
}

class VehicleType extends EnumClass {
  VehicleType._(String name) : super(name);

  static const VehicleType car = _$car;
  static const VehicleType train = _$train;

  static BuiltSet<VehicleType> get values => _$values;
  static VehicleType valueOf(String name) => _$valueOf(name);

  static Serializer<VehicleType> get serializer => _$vehicleTypeSerializer;
}
