import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../Model/Note.dart';

class Db {
  Db._();
  static final Db db = Db._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ProductDB.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE NOTE ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "note TEXT"
          ")");
    });
  }

  Future<List<Note>> gettAll() async {
    List<Note> _list = <Note>[];

    final db = await database;

    List<Map> res = await db.query("NOTE", columns: Note.columns);

    res.forEach((element) {
      Note note = Note.fromMap(element);
      _list.add(note);
    });

    return _list;
  }

  Future<Note> getById(int id) async {
    final db = await database;

    List<Map> res = await db
        .query("NOTE", columns: Note.columns, where: "id = ?", whereArgs: [id]);

    Note note = Note.fromMap(res.first);
    return note;
  }

  Future<int> updateById(Note note) async {
    final db = await database;

    var res = await db.update("NOTE", {"title": note.title, "note": note.note},
        where: "id = ?", whereArgs: [note.id]);

    return res;
  }

  Future<bool> deleteById(int id) async {
    final db = await database;

    var res = db.delete("NOTE", where: "id = ?", whereArgs: [id]);

    return true;
  }

  Future<int> insert(Note note) async {
    final db = await database;

    var res = db.insert("NOTE", note.toMap());

    return res;
  }

  Future<void> deleteAll() async {
    final db = await database;

    var res = await db.delete("Note");
  }
}
