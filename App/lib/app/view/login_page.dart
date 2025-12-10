 import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'welcome_page.dart';

class LoginPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  
  const LoginPage({super.key, required this.notificationsPlugin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // Credenciales hardcodeadas (para demo)
  final String username = 'admin';
  final String password = '1234';

  String mensaje = '';
  bool _isPasswordVisible = false;

  void validarLogin() {
    if (userController.text == username && passController.text == password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(
            notificationsPlugin: widget.notificationsPlugin,
          ),
        ),
      );
    } else {
      setState(() {
        mensaje = 'Credenciales incorrectas';
      });
      
      // Limpiar mensaje de error después de 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => mensaje = '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Fondo con Gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF009688), // Teal más oscuro
                  Color(0xFF80CBC4), // Teal más claro
                  Color(0xFFE0F2F1), // Casi blanco
                ],
              ),
            ),
          ),
          
          // 2. Elementos decorativos de fondo (Círculos)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 3. Contenido Principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Imagen con sombra
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/Vector.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // Tarjeta del Formulario (Glassmorphism style simulado)
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Bienvenido',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00695C),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ingresa a tu cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Input Usuario
                        TextField(
                          controller: userController,
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: const Icon(Icons.person_outline, color: Colors.teal),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Input Contraseña
                        TextField(
                          controller: passController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.teal, width: 1.5),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Mensaje de Error Animado
                        AnimatedOpacity(
                          opacity: mensaje.isNotEmpty ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  mensaje,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Botón Ingresar
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Colors.teal, Color(0xFF4DB6AC)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: validarLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'INGRESAR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Footer texto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta? ',
                        style: TextStyle(color: Colors.teal[800]),
                      ),
                      GestureDetector(
                        onTap: () {}, // Acción futura
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}