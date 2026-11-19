import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int? taskId;

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TasksViewModel>().findTask(taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: task == null
          ? const Center(child: Text('No se encontró esta tarea.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(task.description),
                const SizedBox(height: 16),
                Text('Prioridad: ${task.priority}'),
                Text(
                  task.isCompleted ? 'Estado: completada' : 'Estado: pendiente',
                ),
                Text('Usuario: ${task.userId}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<TasksViewModel>().toggleCompleted(task.id);
                  },
                  child: Text(
                    task.isCompleted
                        ? 'Marcar como pendiente'
                        : 'Marcar como completada',
                  ),
                ),
              ],
            ),
    );
  }
}
