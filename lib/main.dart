import 'package:cats/src/models/fact.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  /// Starting binding widgets
  WidgetsFlutterBinding.ensureInitialized();

  /// Hive database
  await Hive.initFlutter();

  // Adapter Facts
  Hive.registerAdapter(FactAdapter());
  await Hive.openBox<Fact>('facts');
  // Other adapters
  //Hive.registerAdapter(FactAdapter());
  //await Hive.openBox<Fact>('facts');

  /// Set start settings
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  /// Run main app
  runApp(MyApp(settingsController: settingsController));
}
