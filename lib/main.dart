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

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _pendingTasks = 3;

  void _addTask() {
    setState(() {
      _pendingTasks++;
    });
  }

  void _completeTask() {
    if (_pendingTasks == 0) return;

    setState(() {
      _pendingTasks--;
    });
  }

  @override
  Widget build(BuildContext context) {
    const studentName = 'Yandri Macias';
    const courseName = 'Desarrollo de aplicaciones móviles';
    const motivationalMessage = '¡Organiza tus tareas y alcanza tus metas hoy!';

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: Colors.indigo, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text('Bienvenido/a a $courseName.'),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tareas pendientes: $_pendingTasks',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
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
                        onPressed: _pendingTasks == 0 ? null : _completeTask,
                        icon: const Icon(Icons.check),
                        label: const Text('Completar tarea'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
