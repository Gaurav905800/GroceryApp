import 'package:flutter/material.dart';
import 'package:grocery_app/pages/splash_screen.dart';
import 'package:grocery_app/state/cart_provider.dart';
import 'package:grocery_app/state/favorite_provider.dart';
import 'package:grocery_app/state/provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://oaeljyquxgfqjqdqxmyi.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hZWxqeXF1eGdmcWpxZHF4bXlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEzOTIzMzYsImV4cCI6MjA0Njk2ODMzNn0.02a-viWGUBNq0QiwBe126bDgafNZfHluERFItGr8sSo",
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 105, 30, 25),
  ));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroceryProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 197, 102, 102),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
