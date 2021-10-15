import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica3/src/database/database_tareas.dart';
import 'package:practica3/src/models/tareas_model.dart';
import 'package:sqflite/sqflite.dart';

class tareasEntregadasScreen extends StatefulWidget {
  tareasEntregadasScreen({Key? key}) : super(key: key);

  @override
  _tareasEntregadasScreenState createState() => _tareasEntregadasScreenState();
}

class _tareasEntregadasScreenState extends State<tareasEntregadasScreen> {
  late DatabaseTareas _database;
  @override
  void initState() {
    super.initState();
    _database = DatabaseTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tareas entregadas"),
      ),
      body: (FutureBuilder(
        future: _database.getCompleted(),
        builder:
            (BuildContext context, AsyncSnapshot<List<tareasModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Ocurrio un error en la peticion"));
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return _ListadoTareas(snapshot.data!);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      )),
    );
  }

  Widget _ListadoTareas(List<tareasModel> tareas) {
    return ListView.builder(
        itemCount: tareas.length,
        itemBuilder: (BuildContext context, index) {
          tareasModel tarea = tareas[index];
          var fechaLimite = DateFormat('MM/dd/yyyy').parse(tarea.fechaEntrega!);
          var fechaEntrega = DateFormat('MM/dd/yyyy').parse(tarea.entregada!);
          return Card(
            child: ListTile(
              tileColor: fechaEntrega.isAfter(fechaLimite)
                  ? Colors.redAccent
                  : Colors.greenAccent,
              title: Text(tarea.nomTarea!),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text("Fecha de entrega: "),
                      Text(tarea.fechaEntrega!),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Entregada: "),
                      Text(tarea.entregada!),
                    ],
                  ),
                ],
              ),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Eliminar???"),
                        content: Text(
                            'Esta seguro que desea eliminar esta tarea? Se eliminara de forma permanente'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _database.delete(tarea.idTarea!).then((value) {
                                  if (value > 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("El registro se ha eliminado"),
                                      ),
                                    );
                                    setState(() {});
                                  }
                                });
                              },
                              child: Text('Aceptar')),
                        ],
                      );
                    });
              },
            ),
          );
        });
  }
}
