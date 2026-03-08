import '../entities/captured_image.dart';

abstract class SyncRepository {
  Future<void> init();
  Future<void> saveImage(String path);
  List<CapturedImage> getPendingUploads();
  Future<void> markAsSynced(String id);
  Future<void> deleteImage(String id);
  Stream<dynamic> watchPendingUploads();
}
