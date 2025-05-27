import 'package:flutter/material.dart';
import 'package:laboratorio04/app/view/components/h1.dart';
import 'package:laboratorio04/app/view/components/shape.dart';
import 'package:laboratorio04/app/view/task_list/task_list_page.dart'; // Asegúrate de importar tu TaskListPage

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      body: SafeArea(
        child: Column(
          children: [
            // Vector.png arriba
            Row(
              children: [
                const Row(children: [Shape()]),
              ],
            ),

            const SizedBox(height: 99),
            const H1(text: 'Lista de tareas'),
            const SizedBox(height: 21),

            // Texto principal
            Text(
              'Lista de Tareas',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 21),

            // Texto descriptivo ahora con GestureDetector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TaskListPage(),
                    ),
                  );
                },
                child: const Text(
                  'La mejor forma para que no se te olvide nada es anotarlo.\n'
                  'Guarda tus tareas y ve completando poco a poco para aumentar tu productividad.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


