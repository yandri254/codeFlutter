import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Leer documentación',
      description: 'Revisar el material de Flutter',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Diseñar pantalla',
      description: 'Dibujar la lista de tareas',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Preparar evidencia',
      description: 'Capturar pantallas y verificar funcionamiento',
      priority: 'Baja',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Organizar pendientes',
      description: 'Clasificar actividades semanales por prioridad',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Revisar el proyecto',
      description: 'Comprobar estructura de carpetas y ejecutar análisis',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  List<Task> getTasks() {
    return List.unmodifiable(_tasks);
  }

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }
}