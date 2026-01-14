import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/dark_theme.dart';
import 'package:tasky/core/theme/light_theme.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/screens/main_screen/main_screen.dart';
import 'package:tasky/screens/welcome_screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager().init();
  ThemeController().init();
  String? username = PreferencesManager().getString("username");
  /*final asyncPrefs = SharedPreferencesAsync();
  String? username = await asyncPrefs.getString("username");*/
  //asyncPrefs.clear();

  runApp(MyApp(usernameV: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.usernameV});

  final String? usernameV;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (BuildContext context, ThemeMode value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tasky',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeController.themeNotifier.value,
          home: usernameV == null ? WelcomeScreen() : MainScreen(),
          //home: username == null ? welcomeScreenTwo() : HomeScreenTwo(),
        );
      },
    );
  }
}
