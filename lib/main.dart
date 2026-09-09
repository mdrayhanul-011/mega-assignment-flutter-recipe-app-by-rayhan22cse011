import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home/home_screen.dart';
import 'utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'providers/recipe_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => RecipeProvider(),
      ),
    ],
    child: const RecipeApp(),
  ),
);

}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}