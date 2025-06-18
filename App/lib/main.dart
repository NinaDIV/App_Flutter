import 'package:MULTIAPP/app/model/task.dart';
import 'package:MULTIAPP/app/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  // Inicializa Supabase
  await Supabase.initialize(
    url: 'https://ehldtwglpgofukwirpum.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVobGR0d2dscGdvZnVrd2lycHVtIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0ODM2NTk2MywiZXhwIjoyMDYzOTQxOTYzfQ.vjXvdEnA0779H4NYM9gpTP9QPSGf2VTLm-dZ9ADCQAE',
  );

  // Inicializa notificaciones locales
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // CONFIGURACIÓN ESENCIAL PARA ANDROID 13+ (incluye Android 14)
  final androidImplementation = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  
  if (androidImplementation != null) {
    // Solicita permisos de notificación para Android 13+
    await androidImplementation.requestNotificationsPermission();
    
    // Solicita permisos de alarmas exactas (opcional, para notificaciones programadas)
    await androidImplementation.requestExactAlarmsPermission();
  }

  runApp(MyApp(notificationsPlugin: flutterLocalNotificationsPlugin));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const MyApp({super.key, required this.notificationsPlugin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: LoginPage(notificationsPlugin: notificationsPlugin),
    );
  }
}