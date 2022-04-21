import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/task_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider dataBase = DBProvider._();
  static late Database _database;

  Future<Database> get database async {
    _database = await initDataBase();
    return _database;
  }

  initDataBase() async {
    return await openDatabase(join(await getDatabasesPath(), "todo_app_db.db"),
        onCreate: ((db, version) async {
      await db.execute('''
  CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT,task TEXT, creationDate TEXT)
  ''');
    }), version: 1);
  }

  //adding new task
  addNewTask(Task newTask) async {
    final db = await database;
    db.insert("tasks", newTask.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //getting from db
  Future<dynamic> getTask() async {
    final db = await database;
    var res = await db.query("tasks");
    if (res.isEmpty) {
      return null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : null;
    }
  }

  //deleting from db
  Future<int> delete(int id) async {
    final db = await database;
    return await db.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  }
}
