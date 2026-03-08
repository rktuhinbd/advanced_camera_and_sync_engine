import 'package:hive/hive.dart';

part 'captured_image.g.dart';

@HiveType(typeId: 0)
class CapturedImage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String path;

  @HiveField(2)
  final DateTime capturedAt;

  @HiveField(3)
  bool isSynced;

  CapturedImage({
    required this.id,
    required this.path,
    required this.capturedAt,
    this.isSynced = false,
  });

  CapturedImage copyWith({
    String? id,
    String? path,
    DateTime? capturedAt,
    bool? isSynced,
  }) {
    return CapturedImage(
      id: id ?? this.id,
      path: path ?? this.path,
      capturedAt: capturedAt ?? this.capturedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
