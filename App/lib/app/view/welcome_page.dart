import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laboratorio04/app/view/Notificaciones/notificacion.dart';
import 'package:laboratorio04/app/view/home/home_screen.dart';
import 'package:laboratorio04/app/view/task_list/task_list_page.dart';
import 'package:laboratorio04/app/view/uso_de_supabase/gestion_productos_supabase.dart';
import 'second_page.dart';

class WelcomePage extends StatelessWidget {
  
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  const WelcomePage({super.key, required this.notificationsPlugin});



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const Text(
                  '¡Bienvenido de nuevo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 30),

                // Imagen con sombra suave
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 85,
                    backgroundImage: AssetImage('assets/images/nacho.jpg'),
                  ),
                ),

                const SizedBox(height: 40),

                // Botones alineados verticalmente
                _buildWideButton(
                  context,
                  icon: Icons.logout,
                  label: 'Cerrar sesión',
                  color: Colors.redAccent,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),

                _buildWideButton(
                  context,
                  icon: Icons.navigate_next,
                  label: 'Ir a la Segunda Página',
                  color: Colors.teal,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecondPage()),
                  ),
                ),
                const SizedBox(height: 20),

                _buildWideButton(
                  context,
                  icon: Icons.list_alt,
                  label: 'Ir a Lista de Tareas',
                  color: Colors.deepPurple,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TaskListPage()),
                  ),
                ),
                const SizedBox(height: 20),

                _buildWideButton(
                  context,
                  icon: Icons.store,
                  label: 'Ir a Productos',
                  color: Colors.orange,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  ),
                ),
                
                const SizedBox(height: 20),

                _buildWideButton(
                    context,
                    icon: Icons.shopping_cart,
                    label: 'Ir a Gestión de Productos (directo)',
                    color: Colors.green,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GestionProductosSupabase()),
                    ),
                  ),

                  const SizedBox(height: 20),


                       // Agrega este nuevo botón para notificaciones
                _buildWideButton(
                  context,
                  icon: Icons.notifications,
                  label: 'Notificaciones Locales',
                  color: Colors.indigo,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(
                        notificationsPlugin: notificationsPlugin,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),


                const SizedBox(height: 60),
                const Text(
                  'Explora las funciones desde aquí 👇',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(label, style: const TextStyle(fontSize: 20)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
