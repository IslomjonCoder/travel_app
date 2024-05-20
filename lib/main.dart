import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_app/app.dart';
import 'package:travel_app/core/constants/api_constants.dart';
import 'package:travel_app/core/singleton/local_storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/features/main/home/data/models/category_model.dart';
import 'package:travel_app/features/main/home/data/models/place_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(RegionAdapter());

  await Hive.openBox('favouritesBox');
  await LocalStorageShared.init();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const App());
}

final supabase = Supabase.instance.client;
