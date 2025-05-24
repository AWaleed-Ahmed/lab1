import 'package:flutter/material.dart';
import 'package:mybackend/models/task.dart';

class TaskTaker extends StatefulWidget {
  final Task? task;
  final int? index;
  final Function(Task)? onSave;
  final Function()? onDelete;

  TaskTaker({this.task, this.index, this.onSave, this.onDelete});

  @override
  _TaskTakerState createState() => _TaskTakerState();
}

class _TaskTakerState extends State<TaskTaker> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dateController.text = widget.task!.date;
      _timeController.text = widget.task!.time;
    }
  }

  void _saveTask() {
    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      date: _dateController.text,
      time: _timeController.text,
    );
    if (widget.onSave != null) widget.onSave!(task);
    Navigator.pop(context);
  }

  void _deleteTask() {
    if (widget.onDelete != null) widget.onDelete!();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: _dateController, decoration: InputDecoration(labelText: 'Date')),
            TextField(controller: _timeController, decoration: InputDecoration(labelText: 'Time')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text(isEditing ? 'Update Task' : 'Save Task'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            if (isEditing)
              TextButton(
                onPressed: _deleteTask,
                child: Text('Delete Task', style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
