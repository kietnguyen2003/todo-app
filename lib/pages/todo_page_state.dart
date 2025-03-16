import 'package:data_visualization/pages/todo_filter.dart';
import 'package:data_visualization/pages/todo_search_page.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const TodoListPage(filter: TodoFilter.all);
        break;
      case 1:
        page = const TodoListPage(filter: TodoFilter.today);
        break;
      case 2:
        page = const TodoListPage(filter: TodoFilter.upcoming);
        break;
      default:
        page = const TodoSearchPage();
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.all_inbox),
                  label: Text('All'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_today),
                  label: Text("Today"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.calendar_month),
                  label: Text("Upcoming"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(child: page),
        ],
      ),
    );
  }
}
