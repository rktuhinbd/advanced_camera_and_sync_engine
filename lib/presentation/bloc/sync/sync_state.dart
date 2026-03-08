import 'package:equatable/equatable.dart';
import '../../../../domain/entities/captured_image.dart';

abstract class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

class SyncInitial extends SyncState {}

class SyncLoading extends SyncState {}

class SyncLoaded extends SyncState {
  final List<CapturedImage> pendingUploads;

  const SyncLoaded({required this.pendingUploads});

  @override
  List<Object?> get props => [pendingUploads];
}

class SyncError extends SyncState {
  final String message;

  const SyncError(this.message);

  @override
  List<Object?> get props => [message];
}
