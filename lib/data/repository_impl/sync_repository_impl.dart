import 'package:uuid/uuid.dart';
import '../../domain/entities/captured_image.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasource/local_datasource.dart';

class SyncRepositoryImpl implements SyncRepository {
  final LocalDataSource _localDataSource;

  SyncRepositoryImpl(this._localDataSource);

  @override
  Future<void> init() async {
    await _localDataSource.init();
  }

  @override
  Future<void> saveImage(String path) async {
    final image = CapturedImage(
      id: const Uuid().v4(),
      path: path,
      capturedAt: DateTime.now(),
      isSynced: false,
    );
    await _localDataSource.saveImage(image);
  }

  @override
  List<CapturedImage> getPendingUploads() {
    return _localDataSource.getPendingUploads();
  }

  @override
  Future<void> markAsSynced(String id) async {
    await _localDataSource.markAsSynced(id);
  }

  @override
  Future<void> deleteImage(String id) async {
    await _localDataSource.deleteImage(id);
  }

  @override
  Stream<dynamic> watchPendingUploads() {
    return _localDataSource.watchPendingUploads();
  }
}
