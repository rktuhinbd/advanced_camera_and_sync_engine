import 'package:hive/hive.dart';
import '../../domain/entities/captured_image.dart';

class LocalDataSource {
  static const String _boxName = 'captured_images_box';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CapturedImageAdapter());
    }
    await Hive.openBox<CapturedImage>(_boxName);
  }

  Box<CapturedImage> get _box => Hive.box<CapturedImage>(_boxName);

  Future<void> saveImage(CapturedImage image) async {
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
