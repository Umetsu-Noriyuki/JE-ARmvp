import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:ar_app/core/utils/json_reader.dart';
import 'package:ar_app/data/models/ar_object/ar_object_content.dart';
import 'package:ar_app/data/models/ar_object/ar_pose.dart';

/// [ArObjectContent] を JSON 文字列として保存する
class ArObjectContentConverter extends TypeConverter<ArObjectContent, String> {
  const ArObjectContentConverter();

  @override
  ArObjectContent fromSql(String fromDb) {
    return ArObjectContent.fromJson(JsonReader.asObject(jsonDecode(fromDb)));
  }

  @override
  String toSql(ArObjectContent value) => jsonEncode(value.toJson());
}

/// [ArPose] を JSON 文字列として保存する
class ArPoseConverter extends TypeConverter<ArPose, String> {
  const ArPoseConverter();

  @override
  ArPose fromSql(String fromDb) {
    return ArPose.fromJson(JsonReader.asObject(jsonDecode(fromDb)));
  }

  @override
  String toSql(ArPose value) => jsonEncode(value.toJson());
}
