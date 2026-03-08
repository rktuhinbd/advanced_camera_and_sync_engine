import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class SyncLoadPending extends SyncEvent {}

class SyncTriggerUpload extends SyncEvent {}

class SyncImagesUpdated extends SyncEvent {}
