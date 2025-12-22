import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampStringConverter implements JsonConverter<String?, dynamic> {
  const TimestampStringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) {
      return json.toDate().toIso8601String();
    } else if (json is String) {
      return json;
    }
    return null;
  }

  @override
  dynamic toJson(String? object) {
    if (object == null) return null;
    return Timestamp.fromDate(DateTime.parse(object));
  }
}
