import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app_with_changing_theme/db/db_helper.dart';
import 'package:to_do_app_with_changing_theme/screens/home_page.dart';
import 'package:to_do_app_with_changing_theme/screens/theme.dart';
import 'package:to_do_app_with_changing_theme/services/theme_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DbHelper.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeServices().theme,
      theme: Themes.lightMode,
      darkTheme: Themes.darkMode,
      home: const HomePage(),
    );
  }
}
