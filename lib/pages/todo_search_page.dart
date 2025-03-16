import 'package:data_visualization/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodoSearchPage extends StatefulWidget {
  const TodoSearchPage({super.key});

  @override
  State<TodoSearchPage> createState() => _TodoSearchPageState();
}

class _TodoSearchPageState extends State<TodoSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TodoState>();

    List filteredTodos =
        _searchQuery.isEmpty
            ? appState.todos.reversed.take(3).toList()
            : appState.todos.where((todo) {
              return todo.task.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Search',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child:
                filteredTodos.isEmpty
                    ? const Center(child: Text('No matching tasks found'))
                    : ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = filteredTodos[index];
                        String formattedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(todo.date);

                        return ListTile(
                          title: Text(todo.task),
                          subtitle: Text('Due: $formattedDate'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              appState.remove(todo);
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
