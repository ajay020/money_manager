import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'category_model.g.dart';

@HiveType(typeId: 3) // Unique ID for this model
class Category extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int iconCode;

  @HiveField(2)
  final String id;

  Category({
    required this.name,
    required this.iconCode,
    String? id,
  }) : id = id ?? Uuid().v4();

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
}
