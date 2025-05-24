import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/Note.dart';
import 'note_taker.dart';

class NoteView extends StatefulWidget {
  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final noteStrings = prefs.getStringList('notes') ?? [];
    setState(() {
      notes = noteStrings.map((s) => Note.fromJson(json.decode(s))).toList();
    });
  }

  void _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final noteStrings = notes.map((n) => json.encode(n.toJson())).toList();
    await prefs.setStringList('notes', noteStrings);
  }

  void _openNoteTaker({Note? note, int? index}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => NoteTaker(
          note: note,
          onSave: (newNote) {
            setState(() {
              if (index != null) {
                notes[index] = newNote;
              } else {
                notes.add(newNote);
              }
              _saveNotes();
            });
          },
          onDelete: index != null
              ? () {
            setState(() {
              notes.removeAt(index);
              _saveNotes();
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
      appBar: AppBar(title: Text('My Notes')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () => _openNoteTaker(note: note, index: index),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(
                  note.content.length > 50
                      ? '${note.content.substring(0, 50)}...'
                      : note.content,
                ),
                trailing: Text('${note.date.month}/${note.date.day}'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openNoteTaker(),
      ),
    );
  }
}
