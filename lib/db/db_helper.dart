import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:to_do_app_with_changing_theme/models/task.dart';

class DbHelper {
  static Database? _db;
  static final int _version = 1;
  static final _tableName = 'tasks';
  static Future<void> initDb() async {
    if (_db != null) return;
    try {
      String _path = await getDatabasesPath() + 'task.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
          print('creating new one');
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "isCompleted INTEGER, color STRING)"
          );
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }
  static Future<int> insert(Task? task)async{
    log('insert function called');
    return await _db?.insert(_tableName, task!.toJson())??1;
  }

  static Future<List<Map<String,dynamic>>> query() async{
    log('query function called');
    return await _db!.query(_tableName);
  }
  static Future<int> delete(Task task) async{
    log('delete method called');
    //delete certain id
    return await _db!.delete(_tableName,where: 'id=?',whereArgs: [task.id]);
  }
  static Future<int> update(int id) async{
    return await _db!.rawUpdate('''
    UPDATE tasks 
    SET isCompleted = ?
    WHERE id = ?
    ''',[1,id]);
  }
}
