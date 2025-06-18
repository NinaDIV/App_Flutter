import 'package:MULTIAPP/app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
 

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // App color theme
  final ColorScheme _colorScheme = const ColorScheme(
    primary: Color(0xFF4CAF50),         // Green primary
    secondary: Color(0xFF8BC34A),       // Light green accent
    surface: Colors.white,
    error: Color(0xFFE53935),           // Red for errors/delete
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Color(0xFF212121),
    onError: Colors.white,
    brightness: Brightness.light,
  );

  // Add a new task
  void _addTask(String title) {
    final newTask = Task(title: title);
    taskBox.add(newTask);
    setState(() {});
  }

  // Get progress color based on completion percentage
  Color _getProgressColor(double progress) {
    if (progress < 0.3) {
      return const Color(0xFFE57373); // Light red for low progress
    } else if (progress < 0.7) {
      return const Color(0xFFFFB74D); // Light orange for medium progress
    } else {
      return const Color(0xFF81C784); // Light green for high progress
    }
  }

  // Remove a task
  void _removeTask(int index) {
    taskBox.deleteAt(index);
    setState(() {});
  }

  // Toggle task status
  void _toggleTaskStatus(int index) {
    final task = taskBox.getAt(index);
    task?.isDone = !(task.isDone ?? false);
    task?.save();
    setState(() {});
  }

  // Edit a task
  void _editTask(int index, String newTitle) {
    final task = taskBox.getAt(index);
    task?.title = newTitle;
    task?.save();
    setState(() {});
  }

  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  @override
  Widget build(BuildContext context) {
    final tasks = taskBox.values.toList();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),  // Slight off-white background
      appBar: AppBar(
        elevation: 0,  // Remove shadow
        backgroundColor: _colorScheme.primary,
        foregroundColor: _colorScheme.onPrimary,
        title: const Text(
          'Mis Tareas',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header Section with Background Image
          Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  'assets/images/nacho.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient overlay
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Header Text
              Positioned(
                bottom: 30,
                left: 30,
                right: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completa tus tareas',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Organiza tu día y alcanza tus metas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insights_rounded,
                        color: _colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Progreso de tareas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  
                  // Task completion stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${tasks.where((task) => task.isDone).length}/${tasks.length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Tareas completadas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: _colorScheme.primary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${(tasks.where((task) => task.isDone).length / (tasks.isEmpty ? 1 : tasks.length) * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _getProgressColor(tasks.isEmpty
                                  ? 0
                                  : tasks.where((task) => task.isDone).length / tasks.length),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 18),
                  
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: LinearProgressIndicator(
                      value: tasks.isEmpty
                          ? 0
                          : tasks.where((task) => task.isDone).length / tasks.length,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(tasks.isEmpty
                            ? 0
                            : tasks.where((task) => task.isDone).length / tasks.length),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Tasks List Header
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mis tareas (${tasks.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.sort_rounded,
                    color: _colorScheme.primary,
                  ),
                  onPressed: () {
                    // Implement sorting functionality
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Tasks List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: taskBox.listenable(),
              builder: (context, Box<Task> box, _) {
                final tasks = box.values.toList();

                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 80,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay tareas pendientes',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Toca el botón + para agregar una nueva tarea',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return _TaskItem(
                      task: tasks[index],
                      onTap: () => _toggleTaskStatus(index),
                      onRemove: () => _removeTask(index),
                      onEdit: (newTitle) => _editTask(index, newTitle),
                      colorScheme: _colorScheme,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _colorScheme.primary,
        elevation: 4,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTaskTitle = '';
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.add_task,
                      color: _colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    const Text('Nueva tarea'),
                  ],
                ),
                content: TextField(
                  onChanged: (value) {
                    newTaskTitle = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Título de la tarea',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _colorScheme.primary),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (newTaskTitle.isNotEmpty) {
                        _addTask(newTaskTitle);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text('Agregar'),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final Function(String)? onEdit;
  final ColorScheme colorScheme;

  const _TaskItem({
    required this.task,
    required this.onTap,
    this.onRemove,
    this.onEdit,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onRemove,
        onDoubleTap: () {
          String updatedTitle = task.title;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  const Text('Editar tarea'),
                ],
              ),
              content: TextField(
                onChanged: (value) => updatedTitle = value,
                controller: TextEditingController(text: task.title),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    onEdit!(updatedTitle);
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Guardar'),
                  ),
                ),
              ],
            ),
          );
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: task.isDone
                  ? colorScheme.primary.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          color: task.isDone
              ? colorScheme.primary.withOpacity(0.05)
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Checkbox with animation
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: task.isDone ? colorScheme.primary : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isDone
                            ? colorScheme.primary
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: task.isDone
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Task title
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: task.isDone ? FontWeight.normal : FontWeight.w500,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.isDone
                          ? Colors.grey.shade500
                          : Colors.grey.shade800,
                    ),
                  ),
                ),
                
                // Delete button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: colorScheme.error.withOpacity(0.7),
                    size: 22,
                  ),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}