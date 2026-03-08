import '../repositories/sync_repository.dart';

class SaveImageUseCase {
  final SyncRepository repository;

  SaveImageUseCase(this.repository);

  Future<void> call(String path) async {
    await repository.saveImage(path);
  }
}
