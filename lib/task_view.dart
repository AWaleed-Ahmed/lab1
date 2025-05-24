import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_taker.dart';
import 'package:mybackend/models/task.dart';

class TaskView extends StatefulWidget {
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = tasksJson.map((taskStr) => Task.fromJson(jsonDecode(taskStr))).toList();
    });
  }

  Future<void> _saveTasksToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _openTaskTaker({Task? task, int? index}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => TaskTaker(
          task: task,
          index: index,
          onSave: (updatedTask) {
            setState(() {
              if (index != null) {
                tasks[index] = updatedTask;
              } else {
                tasks.add(updatedTask);
              }
              _saveTasksToPrefs();
            });
          },
          onDelete: index != null
              ? () {
            setState(() {
              tasks.removeAt(index);
              _saveTasksToPrefs();
            });
          }
              : null,
        ),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onTap: () => _openTaskTaker(task: task, index: index),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(task.title),
                subtitle: Text('${task.description}\nDate: ${task.date}  Time: ${task.time}'),
                isThreeLine: true,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskTaker(),
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
