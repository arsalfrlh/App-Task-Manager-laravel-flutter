import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmanager/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();
  factory DatabaseHelper() => instance;

  DatabaseHelper.internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'task.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version){
        return db.execute(
          'CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT, gambar TEXT, title TEXT, deskripsi TEXT, status TEXT)',
        );
      });
  }

  Future<List<Task>> getAllTask()async{
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query('task');
    return List.generate(data.length, (i){
      return Task.fromDataBase(data[i]);
    });
  }

  Future<void> addTask(Task task)async{
    final db = await database;
    await db.insert('task', task.toDataBase());
  }

  Future<void> statusUpdate(Task task, int id)async{
    final db = await database;
    await db.update('task', task.toDataBase(), where: 'id = ?', whereArgs: [id]); //bisa juga menggunakan| await db.update('task', task.toDataBase(), where: 'id = $id')| menggunakan WhereArgs karena agar aman dri SQLInjection
  }

  Future<void> deleteTask(int id)async{
    final db = await database;
    await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(Task task, int id)async{
    final db = await database;
    await db.update('task', task.toDataBase(), where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getDoneTask()async{
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query('task', where: 'status = ?', whereArgs: ['selesai']); //bisa juga menggunakan ini final List<Map<String, dynamic>> data = await db.query('task', where: 'status = "selesai"');
    return List.generate(data.length, (i){
      return Task.fromDataBase(data[i]);
    });
  }

  Future<List<Task>> getNotDoneTask()async{
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query('task', where: 'status = ?', whereArgs: ['belum selesai']);
    return List.generate(data.length, (i){
      return Task.fromDataBase(data[i]);
    });
  }

  Future<List<Task>> searchTask(String cari)async{
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query('task', where: 'title LIKE ?', whereArgs: [cari]); //bisa juga mengguankan ini final List<Map<String, dynamic>> data = await db.query('task', where: 'title LIKE $cari');
    return List.generate(data.length, (i){
      return Task.fromDataBase(data[i]);
    });
  }
}
