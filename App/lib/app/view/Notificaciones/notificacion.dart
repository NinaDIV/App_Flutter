import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const NotificationPage({super.key, required this.notificationsPlugin});

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_id',
      'Canal Notificaciones',
      channelDescription: 'Canal de prueba',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(0, title, body, notificationDetails);
  }

  void _openNotificationDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Notificación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titulo'),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'Mensaje'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final body = bodyController.text;
                if (title.isNotEmpty && body.isNotEmpty) {
                  _showNotification(title, body);
                  Navigator.pop(context);
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _openNotificationDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: const Text('Crear Notificación'),
        ),
      ),
    );
  }
}