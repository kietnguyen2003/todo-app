import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:data_visualization/models/todo.dart';
import 'package:data_visualization/dialog/add_task.dart';

enum TodoFilter { all, today, upcoming }

class TodoListPage extends StatelessWidget {
  final TodoFilter filter;

  const TodoListPage({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    var todoState = context.watch<TodoState>();
    var today = DateTime.now();

    var todos =
        todoState.todos.where((todo) {
          if (filter == TodoFilter.today) {
            return todo.date.day == today.day &&
                todo.date.month == today.month &&
                todo.date.year == today.year;
          } else if (filter == TodoFilter.upcoming) {
            return todo.date.isAfter(today);
          }
          return true;
        }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _getTitle(),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body:
          todos.isEmpty
              ? const Center(child: Text("Nothing to do. Tap + to create one!"))
              : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  var todo = todos[index];
                  String formattedDate = DateFormat(
                    'dd/MM/yyyy',
                  ).format(todo.date);

                  return ListTile(
                    title: Text(todo.task),
                    subtitle: Text('Due: $formattedDate'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Xác nhận xóa'),
                                  content: const Text(
                                    'Bạn chắc chắn muốn xóa công việc này?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        todoState.remove(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Xóa'),
                                    ),
                                  ],
                                ),
                          ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getTitle() {
    switch (filter) {
      case TodoFilter.today:
        return 'Today Deadline';
      case TodoFilter.upcoming:
        return 'Upcoming Deadline';
      case TodoFilter.all:
      default:
        return 'All Deadlines';
    }
  }
}
