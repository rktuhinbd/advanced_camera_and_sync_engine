import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/sync_repository.dart';
import '../../../../domain/usecases/get_pending_uploads_usecase.dart';
import '../../../../core/utils/workmanager_setup.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncRepository _syncRepository;
  final GetPendingUploadsUseCase _getPendingUploadsUseCase;
  StreamSubscription<dynamic>? _boxSubscription;

  SyncBloc(this._syncRepository, this._getPendingUploadsUseCase)
    : super(SyncInitial()) {
    on<SyncLoadPending>(_onLoadPending);
    on<SyncTriggerUpload>(_onTriggerUpload);
    on<SyncImagesUpdated>(_onImagesUpdated);

    // Watch for Hive changes
    _boxSubscription = _syncRepository.watchPendingUploads().listen((_) {
      add(SyncImagesUpdated());
    });
  }

  void _onLoadPending(SyncLoadPending event, Emitter<SyncState> emit) {
    emit(SyncLoading());
    try {
      final pendingImages = _getPendingUploadsUseCase();
      emit(SyncLoaded(pendingUploads: pendingImages));
    } catch (e) {
      emit(SyncError(e.toString()));
    }
  }

  void _onImagesUpdated(SyncImagesUpdated event, Emitter<SyncState> emit) {
    if (state is SyncLoaded || state is SyncLoading || state is SyncInitial) {
      try {
        final pendingImages = _getPendingUploadsUseCase();
        emit(SyncLoaded(pendingUploads: pendingImages));

        // Trigger Workmanager if there's new data
        if (pendingImages.isNotEmpty) {
          add(SyncTriggerUpload());
        }
      } catch (e) {
        emit(SyncError(e.toString()));
      }
    }
  }

  void _onTriggerUpload(SyncTriggerUpload event, Emitter<SyncState> emit) {
    WorkmanagerSetup.registerUploadTask();
  }

  @override
  Future<void> close() {
    _boxSubscription?.cancel();
    return super.close();
  }
}
