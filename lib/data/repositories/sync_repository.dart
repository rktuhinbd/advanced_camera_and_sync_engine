import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/captured_image.dart';

class SyncRepository {
  static const String _boxName = 'captured_images_box';

  Future<void> init() async {
    Hive.registerAdapter(CapturedImageAdapter());
    await Hive.openBox<CapturedImage>(_boxName);
  }

  Box<CapturedImage> get _box => Hive.box<CapturedImage>(_boxName);

  Future<void> saveImage(String path) async {
    final image = CapturedImage(
      id: const Uuid().v4(),
      path: path,
      capturedAt: DateTime.now(),
      isSynced: false,
    );
    await _box.put(image.id, image);
  }

  List<CapturedImage> getPendingUploads() {
    return _box.values.where((image) => !image.isSynced).toList();
  }

  Future<void> markAsSynced(String id) async {
    final image = _box.get(id);
    if (image != null) {
      image.isSynced = true;
      await image.save();
    }
  }

  Future<void> deleteImage(String id) async {
    await _box.delete(id);
  }

  Stream<BoxEvent> watchPendingUploads() {
    return _box.watch();
  }
}
