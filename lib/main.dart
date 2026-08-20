import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/api/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Core Services
  final localStorage = await LocalStorageService.init();
  final secureStorage = SecureStorageService();
  final apiClient = ApiClient(secureStorage: secureStorage);

  runApp(
    AreaKerjaApp(
      localStorageService: localStorage,
      secureStorageService: secureStorage,
      apiClient: apiClient,
    ),
  );
}
