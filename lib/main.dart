import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

enum TaskPriority {
  high('Alta'),
  medium('Media'),
  low('Baja');

  const TaskPriority(this.label);

  final String label;
}

class Task {
  const Task({
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false,
  });

  final String title;
  final String description;
  final TaskPriority priority;
  final bool isCompleted;

  Task copyWith({bool? isCompleted}) {
    return Task(
      title: title,
      description: description,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<Task> _tasks = [
    const Task(
      title: 'Revisar apuntes de Flutter',
      description: 'Repasar widgets y el ciclo de vida de una pantalla.',
      priority: TaskPriority.high,
    ),
    const Task(
      title: 'Diseñar pantalla de inicio',
      description: 'Definir la estructura visual principal de TaskFlow.',
      priority: TaskPriority.medium,
    ),
    const Task(
      title: 'Practicar layouts',
      description: 'Crear ejemplos usando Row, Column y Card.',
      priority: TaskPriority.low,
    ),
    const Task(
      title: 'Preparar entrega del proyecto',
      description: 'Organizar los avances y revisar los requisitos.',
      priority: TaskPriority.high,
      isCompleted: true,
    ),
    const Task(
      title: 'Leer documentación de Dart',
      description: 'Consultar tipos, listas y clases en Dart.',
      priority: TaskPriority.medium,
    ),
  ];

  int get _pendingTasksCount =>
      _tasks.where((task) => !task.isCompleted).length;

  void _addTask() {
    setState(() {
      _tasks.add(
        const Task(
          title: 'Nueva tarea',
          description: 'Tarea agregada a tu lista de TaskFlow.',
          priority: TaskPriority.medium,
        ),
      );
    });
  }

  void _completeTask() {
    final taskIndex = _tasks.indexWhere((task) => !task.isCompleted);
    if (taskIndex == -1) return;

    setState(() {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(isCompleted: true);
    });
  }

  void _showTaskDetails(Task task) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 16),
            Text('Prioridad: ${task.priority.label}'),
            Text('Estado: ${task.isCompleted ? 'Completada' : 'Pendiente'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const studentName = 'Yandri Macias';
    const courseName = 'Desarrollo de aplicaciones móviles';
    const motivationalMessage = '¡Organiza tus tareas y alcanza tus metas hoy!';

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.task_alt, size: 56, color: Colors.indigo),
                  const SizedBox(height: 24),
                  Text(
                    '¡Hola, $studentName!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    motivationalMessage,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Bienvenido/a a $courseName.'),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tareas pendientes: $_pendingTasksCount',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _addTask,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar tarea'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _pendingTasksCount == 0
                                  ? null
                                  : _completeTask,
                              icon: const Icon(Icons.check),
                              label: const Text('Completar tarea'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mis tareas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final task = _tasks[index];
                return TaskCard(
                  task: task,
                  onViewDetails: () => _showTaskDetails(task),
                );
              }, childCount: _tasks.length),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, required this.onViewDetails, super.key});

  final Task task;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onViewDetails,
                  tooltip: 'Ver detalle de ${task.title}',
                  icon: const Icon(Icons.open_in_new),
                ),
              ],
            ),
            Text(task.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Prioridad: ${task.priority.label}')),
                Chip(
                  label: Text(task.isCompleted ? 'Completada' : 'Pendiente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
