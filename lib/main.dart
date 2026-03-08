import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/utils/workmanager_setup.dart';
import 'data/datasource/local_datasource.dart';
import 'data/repository_impl/sync_repository_impl.dart';
import 'domain/repositories/sync_repository.dart';
import 'domain/usecases/get_pending_uploads_usecase.dart';
import 'domain/usecases/save_image_usecase.dart';
import 'presentation/bloc/camera/camera_bloc.dart';
import 'presentation/bloc/sync/sync_bloc.dart';
import 'presentation/bloc/sync/sync_event.dart';
import 'presentation/screens/camera_preview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Background Sync Engine via Workmanager
  await WorkmanagerSetup.init();

  // Initialize Hive and Data Sources
  await Hive.initFlutter();
  final localDataSource = LocalDataSource();
  final syncRepository = SyncRepositoryImpl(localDataSource);
  await syncRepository.init();

  final getPendingUploadsUseCase = GetPendingUploadsUseCase(syncRepository);
  final saveImageUseCase = SaveImageUseCase(syncRepository);

  runApp(
    MyApp(
      syncRepository: syncRepository,
      getPendingUploadsUseCase: getPendingUploadsUseCase,
      saveImageUseCase: saveImageUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SyncRepository syncRepository;
  final GetPendingUploadsUseCase getPendingUploadsUseCase;
  final SaveImageUseCase saveImageUseCase;

  const MyApp({
    super.key,
    required this.syncRepository,
    required this.getPendingUploadsUseCase,
    required this.saveImageUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SyncBloc>(
          create: (context) =>
              SyncBloc(syncRepository, getPendingUploadsUseCase)
                ..add(SyncLoadPending()),
        ),
        BlocProvider<CameraBloc>(
          create: (context) => CameraBloc(saveImageUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'Advanced Camera Sync',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CameraPreviewScreen(),
      ),
    );
  }
}
