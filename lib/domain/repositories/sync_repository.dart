import '../entities/captured_image.dart';

/// Abstract interface for the SyncRepository.
/// Following Clean Architecture, this abstracts the data sources
/// from the domain use cases.
abstract class SyncRepository {
  Future<void> init();
  Future<void> saveImage(String path);
  List<CapturedImage> getPendingUploads();
  Future<void> markAsSynced(String id);
  Future<void> deleteImage(String id);
  Stream<dynamic> watchPendingUploads();
}
