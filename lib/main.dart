import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/dio_quote_repository.dart';
import 'data/shared_prefs_task_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    TaskTrackerApp(
      taskRepository: SharedPrefsTaskRepository(prefs),
      quoteRepository: DioQuoteRepository(Dio()),
    ),
  );
}
