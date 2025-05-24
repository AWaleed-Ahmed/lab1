import 'package:flutter/material.dart';
import '../models/Note.dart';

class NoteTaker extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;
  final Function()? onDelete;

  NoteTaker({this.note, required this.onSave, this.onDelete});

  @override
  _NoteTakerState createState() => _NoteTakerState();
}

class _NoteTakerState extends State<NoteTaker> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  void _saveNote() {
    final note = Note(
      title: _titleController.text,
      content: _contentController.text,
      date: DateTime.now(),
    );
    widget.onSave(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          if (widget.onDelete != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onDelete!();
                Navigator.pop(context);
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Note Title'),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(labelText: 'Note Content'),
              ),
            ),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(isEditing ? 'Update' : 'Save'),
            )
          ],
        ),
      ),
    );
  }
}
