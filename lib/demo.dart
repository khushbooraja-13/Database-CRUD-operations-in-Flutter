import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Demo{
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'demo.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
      await rootBundle.load(join('assets/database', 'demo.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getUser() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> list = await db.rawQuery('select * from user_demo');
    return list;
  }

  Future<int> insertUser(Map<String, dynamic> map) async {
    Database db = await initDatabase();
    int insert = await db.insert('user_demo', map);
    return insert;
  }

  Future<int> deleteUser(int id) async {
    Database db = await initDatabase();
    int delete = await db.delete('user_demo',where: 'userId = ?',whereArgs: [id]);
    return delete;
  }

  Future<int> updateUser(Map<String, dynamic> map) async {
    Database db = await initDatabase();
    int update = await db.update('user_demo', map, where: 'userId = ?',whereArgs: [map['userId']]);
    return update;
  }
}