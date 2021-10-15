import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica3/src/database/database_tareas.dart';
import 'package:practica3/src/models/tareas_model.dart';

class TareasScreen extends StatefulWidget {
  TareasScreen({Key? key}) : super(key: key);

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
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
        title: Text("Tareas pendientes"),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/agregartarea')
                        .whenComplete(() {
                      setState(() {});
                    });
                  },
                  icon: Icon(Icons.add_circle)),
            ],
          )
        ],
      ),
      body: (FutureBuilder(
        future: _database.getIncompleted(),
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
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("Ramirez Montero Juan Luis"),
                accountEmail: Text("ramirez270198@gmail.com")),
            ListTile(
              title: Text('Tareas Entregadas'),
              subtitle: Text('Revisar las tareas entregadas'),
              leading: Icon(Icons.book_outlined),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/entregadas');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _ListadoTareas(List<tareasModel> tareas) {
    DateTime fechaLimite;
    return ListView.builder(
        itemCount: tareas.length,
        itemBuilder: (BuildContext context, index) {
          tareasModel tarea = tareas[index];
          fechaLimite = DateFormat('MM/dd/yyyy').parse(tarea.fechaEntrega!);
          return Card(
            child: ListTile(
              tileColor: fechaLimite.isBefore(DateTime.now())
                  ? Colors.redAccent
                  : Colors.lightBlueAccent,
              title: Text(tarea.nomTarea!),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text("Fecha de entrega: "),
                      Text(tarea.fechaEntrega!),
                    ],
                  ),
                  Row(children: [Text("Entregada: "), Text(tarea.entregada!)]),
                ],
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Seleccione una accion"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/agregartarea',
                                          arguments: tarea)
                                      .whenComplete(() {
                                    setState(() {});
                                  });
                                },
                                child: Text("Editar Tarea")),
                            TextButton(
                                onPressed: () {
                                  tarea.entregada = new DateFormat.yMd()
                                      .format(DateTime.now());
                                  tareasModel t = tareasModel(
                                      idTarea: tarea.idTarea,
                                      dscTarea: tarea.dscTarea,
                                      nomTarea: tarea.nomTarea,
                                      fechaEntrega: tarea.fechaEntrega,
                                      entregada: tarea.entregada);
                                  _database.update(t.toMap()).then((value) {
                                    if (value > 0) {
                                      Navigator.pop(context);
                                      setState(() {});
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "La solicitud no se completo"),
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: Text("Entregar tarea")),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
