import 'package:flutter/foundation.dart';

import '../data/task_repository.dart';
import '../domain/task.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel(TaskRepository repository)
    : _repository = repository,
      _tasks = repository.getTasks();

  final TaskRepository _repository;
  List<Task> _tasks;

  List<Task> get tasks => List.unmodifiable(_tasks);

  Task? findTask(int? id) {
    if (id == null) return null;
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void toggleCompleted(int id) {
    final current = findTask(id);
    if (current == null) return;

    _repository.save(current.copyWith(isCompleted: !current.isCompleted));
    _tasks = _repository.getTasks();
    notifyListeners();
  }
}
