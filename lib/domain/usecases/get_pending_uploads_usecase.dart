import '../entities/captured_image.dart';
import '../repositories/sync_repository.dart';

class GetPendingUploadsUseCase {
  final SyncRepository repository;

  GetPendingUploadsUseCase(this.repository);

  List<CapturedImage> call() {
    return repository.getPendingUploads();
  }
}
