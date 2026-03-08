import '../repositories/sync_repository.dart';

class DeleteImageUseCase {
  final SyncRepository repository;

  DeleteImageUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteImage(id);
  }
}
