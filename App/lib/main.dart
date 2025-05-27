import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laboratorio04/app/view/login_page.dart';
import 'package:laboratorio04/app/model/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter()); // Asegúrate que esté generado
  await Hive.openBox<Task>('tasks');   // Abre tu caja

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Usa tu fuente personalizada
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Puedes cambiar por TaskListPage si quieres empezar allí
    );
  }
}
   