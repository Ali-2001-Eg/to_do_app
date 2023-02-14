import 'dart:developer';

import 'package:get/get.dart';
import 'package:to_do_app_with_changing_theme/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController{
  @override
  void onReady() {
    super.onReady();
  }

  //insert new record
  Future<int>addTask(Task? task) async{
    return await DbHelper.insert(task);
  }

  var taskList = <Task>[].obs;

  //get all data from table
  void getTasks() async{
    List<Map<String,dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void delete(Task task) async{
     await DbHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DbHelper.update(id);
    getTasks();
  }
}