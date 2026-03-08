import 'package:workmanager/workmanager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasource/local_datasource.dart';
import '../../data/repository_impl/sync_repository_impl.dart';
import '../constants/app_constants.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == AppConstants.uploadTask) {
        // Init Hive in background
        final appDocumentDir = await getApplicationDocumentsDirectory();
        Hive.init(appDocumentDir.path);

        final localDataSource = LocalDataSource();
        final syncRepository = SyncRepositoryImpl(localDataSource);
        await syncRepository.init();

        // Connectivity check
        final connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult.contains(ConnectivityResult.none)) {
          return Future.value(
            false,
          ); // No connection, work fails and retries later
        }

        final pendingImages = syncRepository.getPendingUploads();
        if (pendingImages.isEmpty) {
          return Future.value(true);
        }

        for (final image in pendingImages) {
          // Mocking an upload delay
          await Future.delayed(const Duration(seconds: 2));

          await syncRepository.markAsSynced(image.id);
          // Optional: we can delete the file from storage if we no longer need it locally
          // final file = File(image.path);
          // if (await file.exists()) {
          //   await file.delete();
          // }
          // await syncRepository.deleteImage(image.id);
        }

        return Future.value(true);
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

class WorkmanagerSetup {
  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static void registerUploadTask() {
    Workmanager().registerOneOffTask(
      "uploadTask1",
      AppConstants.uploadTask,
      constraints: Constraints(
        networkType: NetworkType.connected, // Require connection for upload
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(seconds: 10),
    );
  }
}
