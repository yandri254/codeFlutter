import '../domain/task.dart';

abstract class TaskRepository {
  List<Task> getTasks();
  void save(Task task);
}
