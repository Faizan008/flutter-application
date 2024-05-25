// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasker/controller/task_controller.dart';
import 'package:tasker/model/task_model.dart';


class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    taskController.fetchTasks();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Task'),
      ),
      body: Obx(() {
        if (taskController.tasks.isEmpty) {
          return const Center(
            child: Text("You don't have any task"),
          );
        }
        return ListView.builder(
          itemCount: taskController.tasks.length,
          itemBuilder: (context, index) {
            final task = taskController.tasks[index];
            return ListTile(
              title: Text(
                task.title!,
                style: TextStyle(
                  decoration: task.isDone! ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text('Due: ${task.dueDate}'),
              leading: Checkbox(
                value: task.isDone,
                onChanged: (value) {
                  taskController.toggleTaskStatus(task.objectId!,!task.isDone);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  taskController.deleteTask(task.objectId!);
                },
              ),
              onTap: () => _showEditTaskModalBottomSheet(context, task),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModalBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: AddTaskBottomSheet(),
        );
      },
    );
  }

  void _showEditTaskModalBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: EditTaskBottomSheet(task: task),
        );
      },
    );
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TaskController taskController = Get.find();
  final TextEditingController textEditingController = TextEditingController();
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Enter task',
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    child: Text('Due Date: $selectedDate'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (textEditingController.text.isNotEmpty &&
                    selectedDate != null) {
                  taskController.addTask(
                      textEditingController.text, selectedDate!);
                  Navigator.pop(context);
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskBottomSheet extends StatefulWidget {
  final Task task;

  EditTaskBottomSheet({required this.task});

  @override
  _EditTaskBottomSheetState createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  final TaskController taskController = Get.find();
  late TextEditingController textEditingController;
  late String? selectedDate;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.task.title);
    selectedDate = widget.task.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: 'Edit task',
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    child: Text('Due Date: $selectedDate'),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (textEditingController.text.isNotEmpty &&
                    selectedDate != null) {
                  taskController.updateTask(
                      widget.task.objectId!, textEditingController.text, selectedDate!);
                  Navigator.pop(context);
                }
              },
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
