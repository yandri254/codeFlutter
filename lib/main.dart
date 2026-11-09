import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatefulWidget {
  const TaskFlowApp({super.key});

  @override
  State<TaskFlowApp> createState() => _TaskFlowAppState();
}

class _TaskFlowAppState extends State<TaskFlowApp> {
  late final TaskStore _taskStore = TaskStore();
  late final GoRouter _router = GoRouter(
    initialLocation: '/tasks',
    routes: [
      GoRoute(
        path: '/tasks',
        builder: (context, state) => WelcomeScreen(store: _taskStore),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final taskId = state.pathParameters['id']!;
              final task = _taskStore.taskById(taskId);
              if (task == null) {
                return const TaskNotFoundScreen();
              }
              return TaskDetailScreen(task: task);
            },
          ),
        ],
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    _taskStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: _router,
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
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final bool isCompleted;

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskStore extends ChangeNotifier {
  final List<Task> _tasks = [
    const Task(
      id: 'task-1',
      title: 'Revisar apuntes de Flutter',
      description: 'Repasar widgets y el ciclo de vida de una pantalla.',
      priority: TaskPriority.high,
    ),
    const Task(
      id: 'task-2',
      title: 'Diseñar pantalla de inicio',
      description: 'Definir la estructura visual principal de TaskFlow.',
      priority: TaskPriority.medium,
    ),
    const Task(
      id: 'task-3',
      title: 'Practicar layouts',
      description: 'Crear ejemplos usando Row, Column y Card.',
      priority: TaskPriority.low,
    ),
    const Task(
      id: 'task-4',
      title: 'Preparar entrega del proyecto',
      description: 'Organizar los avances y revisar los requisitos.',
      priority: TaskPriority.high,
      isCompleted: true,
    ),
    const Task(
      id: 'task-5',
      title: 'Leer documentación de Dart',
      description: 'Consultar tipos, listas y clases en Dart.',
      priority: TaskPriority.medium,
    ),
  ];

  int _nextTaskId = 6;

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get _pendingTasksCount =>
      _tasks.where((task) => !task.isCompleted).length;

  Task? taskById(String id) {
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void addTask() {
    _tasks.add(
      Task(
        id: 'task-${_nextTaskId++}',
        title: 'Nueva tarea',
        description: 'Tarea agregada a tu lista de TaskFlow.',
        priority: TaskPriority.medium,
      ),
    );
    notifyListeners();
  }

  void completeNextTask() {
    final taskIndex = _tasks.indexWhere((task) => !task.isCompleted);
    if (taskIndex == -1) return;

    _tasks[taskIndex] = _tasks[taskIndex].copyWith(isCompleted: true);
    notifyListeners();
  }

  int get pendingTasksCount => _pendingTasksCount;
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({required this.store, super.key});

  final TaskStore store;

  @override
  Widget build(BuildContext context) {
    const studentName = 'Yandri Macias';
    const courseName = 'Desarrollo de aplicaciones móviles';
    const motivationalMessage = '¡Organiza tus tareas y alcanza tus metas hoy!';

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => Scaffold(
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
                            'Tareas pendientes: ${store.pendingTasksCount}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: store.addTask,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar tarea'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: store.pendingTasksCount == 0
                                  ? null
                                  : store.completeNextTask,
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
                final task = store.tasks[index];
                return TaskCard(
                  task: task,
                  onViewDetails: () => context.push('/tasks/${task.id}'),
                );
              }, childCount: store.tasks.length),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(task.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prioridad: ${task.priority.label}'),
                    const SizedBox(height: 8),
                    Text(
                      'Estado: ${task.isCompleted ? 'Completada' : 'Pendiente'}',
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

class TaskNotFoundScreen extends StatelessWidget {
  const TaskNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarea no encontrada')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No existe una tarea con ese identificador.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/tasks'),
              child: const Text('Volver a mis tareas'),
            ),
          ],
        ),
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
