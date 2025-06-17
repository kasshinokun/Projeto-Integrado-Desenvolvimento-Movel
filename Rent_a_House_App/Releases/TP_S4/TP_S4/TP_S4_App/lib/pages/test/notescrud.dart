import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/dbdao/database_helper.dart';
import 'package:rent_a_house/pages/model/note.dart';

void main() {
  runApp(MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyNotesCrudPage(),
    );
  }
}

//Isolar depois---------------------------------------------------------------------------------------------------------------
class MyNotesCrudPage extends StatefulWidget {
  const MyNotesCrudPage({super.key});
  //title: 'Login Demonstração'
  @override
  State<MyNotesCrudPage> createState() => _MyNotesCrudPageState();
}

class _MyNotesCrudPageState extends State<MyNotesCrudPage> {
  final dbHelper = DatabaseHelper.instance;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    List<Note> notes = await dbHelper.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addNote() async {
    Note newNote = Note(name: 'New Note', description: 'Description');
    int id = await dbHelper.insert(newNote);
    setState(() {
      newNote.id = id;
      _notes.add(newNote);
    });
  }

  void _updateNote(int index) async {
    Note updatedNote = Note(
      id: _notes[index].id,
      name: 'Updated Note',
      description: 'Updated Description',
    );
    await dbHelper.update(updatedNote);
    setState(() {
      _notes[index] = updatedNote;
    });
  }

  void _deleteNote(int index) async {
    await dbHelper.delete(_notes[index].id!);
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter SQLite CRUD')),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notes[index].name),
            subtitle: Text(_notes[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _updateNote(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteNote(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addNote();
        },
      ),
    );
  }
}
