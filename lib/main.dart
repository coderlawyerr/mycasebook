import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'wiew/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  // Uygulama başlatıldığında Firebase'i başlatıyoruz ve ardından uygulamayı çalıştırıyoruz.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('tr', ''), // Turkish locale
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Color(0xFF29353C)),
        title: 'Flutter Demo',
        home: const Splash());
  }
}
