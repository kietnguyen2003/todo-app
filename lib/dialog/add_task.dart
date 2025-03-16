// /d:/Dart/Login/data_visualization/data_visualization/lib/dialog/add_task_dialog.dart
import 'package:data_visualization/widgets/add_todo_form.dart';
import 'package:flutter/material.dart';

Future<void> showAddTaskDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      final double screenWidth = MediaQuery.of(context).size.width;
      final double dialogWidth = screenWidth >= 600 ? 400 : screenWidth * 0.9;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(width: dialogWidth, child: const AddTodoForm()),
      );
    },
  );
}
