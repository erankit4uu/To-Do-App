import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/model/to_do_item.dart';


class DatabaseHelper{

 static final DatabaseHelper _instance = new DatabaseHelper.internal();
 factory DatabaseHelper() => _instance;

 final String tableName = "todo";
 final String columnItemName = "itemName";
 final String columnDateCreated = "dateCreated";
 final String columnId = "id";

 static Database _db;

 Future<Database> get db async{
   if(_db != null){
     return _db;
   }
   _db = await initDb();
    return _db;
 }

 DatabaseHelper.internal();

  initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "tododb.db");

    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }
 void _onCreate(Database db, int newVersion) async {
   await db.execute(
       "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columnItemName TEXT, $columnDateCreated TEXT)");

   print("Table Created $tableName");
 }
 Future<int> saveItem(ToDoItem todoitem) async {
   var dbClient = await db;

   int res = await dbClient.insert("$tableName", todoitem.toMap());
   return res;
 }

Future<List> getItems() async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return result.toList();
}

Future<int> getCount() async{
  var dbClient = await db;
  return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
}

Future<int> deleteItem(int id) async{
  var dbClient = await db;
  return await dbClient.delete(tableName,
    where: "$columnId = ?", whereArgs: [id]
  );
}
 Future<int> updateItem(ToDoItem todoitem) async{
   var dbClient = await db;
   return await dbClient.update(tableName, todoitem.toMap(),
       where: "$columnId = ?", whereArgs: [todoitem.id]
   );
 }
 Future close()async{
   var dbClient = await db;
   return dbClient.close();
 }
 Future<ToDoItem> getItem(int id) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if(result.length == 0) return null;
    return new ToDoItem.fromMap(result.first);
 }
}