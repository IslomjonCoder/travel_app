import 'package:flutter/material.dart';
import 'package:travel_app/app.dart';
import 'package:travel_app/core/constants/api_constants.dart';
import 'package:travel_app/core/singleton/local_storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageShared.init();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const App());
}



final supabase = Supabase.instance.client;

