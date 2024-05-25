// lib/task_controller.dart

import 'dart:convert';

import 'package:get/get.dart';
import 'package:tasker/constants.dart';
import 'package:tasker/model/event_object.dart';
import 'package:tasker/services/exports.dart';
import 'package:tasker/services/http_put.dart';
import '../model/task_model.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  final String baseUrl =
      'http://your-backend-url.com'; // Replace with your backend URL
  Task? task;
  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  Future<void> fetchTasks() async {
    try {
      final response = await await httpGet(
        client: http.Client(),
        url: ApiConstants.task,
      );
      if (response.statusCode == 200) {
        final TaskList taskList = TaskList.fromJson(
          json.decode(response.response),
        );
        print(taskList.results);
        var data = taskList.results;
        tasks.value = data!.map((task) => task).toList();
      } else {
        Get.snackbar('Error', 'Failed to load tasks');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load tasks');
    }
  }

  Future<void> addTask(String title, String dueDate) async {
    try {
      final response = await httpPost(
        client: http.Client(),
        url: ApiConstants.task,
        data: jsonEncode(<String, String>{
          'title': title!,
          'dueDate': dueDate!,
        }),
      );
      if (response?.statusCode == 201) {
        fetchTasks();
      } else {
        Get.snackbar('Error', 'Failed to add task');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task');
    }
  }

  Future<void> updateTask(String id, String title, String dueDate) async {
    try {
      final response = await httpPut(
        client: http.Client(),
        url: "${ApiConstants.task}/${id}",
        data: jsonEncode(<String, String>{
          'title': title!,
          'dueDate': dueDate!,
        }),
      );
      if (response?.statusCode == 200) {
        fetchTasks();
      } else {
        Get.snackbar('Error', 'Failed to update task');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task');
    }
  }

  Future<void> toggleTaskStatus(String id, bool status) async {
    try {
      final response = await httpPut(
        client: http.Client(),
        url: ApiConstants.task + "/${id}",
        data: jsonEncode(<String, bool>{'isDone': status}),
      );
      if (response?.statusCode == 200) {
        fetchTasks();
      } else {
        Get.snackbar('Error', 'Failed to update task');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await httpDelete(
          client: http.Client(), url: "${ApiConstants.task}/$id");
      if (response.statusCode == 200) {
        fetchTasks();
      } else {
        Get.snackbar('Error', 'Failed to delete task');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task');
    }
  }
}
