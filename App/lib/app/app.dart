import 'package:flutter/material.dart';
import 'package:laboratorio04/app/view/splash/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DEMO',
      debugShowCheckedModeBanner:
          false, // <-- ESTA ES LA LÍNEA QUE DEBES AGREGAR
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
