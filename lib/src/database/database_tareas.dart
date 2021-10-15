import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:practica3/src/models/tareas_model.dart';

class DatabaseTareas {
  static final _nombreDB = "TareasDB";
  static final _version = 1;
  static final _nombreTabla = "tareas";
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future<Database?> _initDatabase() async {
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaDB = join(carpeta.path, _nombreDB);
    return openDatabase(rutaDB, version: _version, onCreate: _crearTabla);
  }

  _crearTabla(Database db, int version) async {
    await db.execute(
        "create table $_nombreTabla (idTarea integer primary key,nomTarea text, dscTarea text, fechaEntrega text,entregada text);");
  }

  Future<int> insert(Map<String, dynamic> registro) async {
    var conexion = await database;
    return conexion!.insert(_nombreTabla, registro);
  }

  Future<int> update(Map<String, dynamic> registro) async {
    var conexion = await database;
    return conexion!.update(_nombreTabla, registro,
        where: 'idTarea=?', whereArgs: [registro['idTarea']]);
  }

  Future<List<tareasModel>> getCompleted() async {
    var conexion = await database;
    var result = await conexion!.query(_nombreTabla, where: 'entregada <>""');
    return result.map((tareaMap) => tareasModel.fromMap(tareaMap)).toList();
  }

  Future<List<tareasModel>> getIncompleted() async {
    var conexion = await database;
    var result = await conexion!.query(_nombreTabla, where: 'entregada=""');
    return result.map((tareaMap) => tareasModel.fromMap(tareaMap)).toList();
  }

  Future<int> delete(int id) async {
    var conexion = await database;
    return conexion!.delete(_nombreTabla, where: 'idTarea=?', whereArgs: [id]);
  }
}
