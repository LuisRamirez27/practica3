import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practica3/src/database/database_tareas.dart';
import 'package:practica3/src/models/tareas_model.dart';

class agregarTareaScreen extends StatefulWidget {
  agregarTareaScreen({Key? key}) : super(key: key);

  @override
  _agregarTareaScreenState createState() => _agregarTareaScreenState();
}

class _agregarTareaScreenState extends State<agregarTareaScreen> {
  var _currentSelectedDate = new DateFormat.yMd().format(DateTime.now());
  late DatabaseTareas _database;
  var tarea;
  TextEditingController _controllerNomTarea = TextEditingController();
  TextEditingController _controllerDscTarea = TextEditingController();
  @override
  void initState() {
    super.initState();
    _database = DatabaseTareas();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      tarea = ModalRoute.of(context)!.settings.arguments as tareasModel;
      _controllerNomTarea.text = tarea.nomTarea!;
      _controllerDscTarea.text = tarea.dscTarea!;
      _currentSelectedDate = tarea.fechaEntrega!;
    }
    return Scaffold(
      appBar: AppBar(
          title: tarea == null
              ? Text("Agregar nueva tarea")
              : Text("Editar tarea")),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        children: [
          TextField(
            controller: _controllerNomTarea,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Nombre de la tarea',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: _controllerDscTarea,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: 'Descripcion de la tarea',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            title: Text("Fecha de entrega "),
            onTap: datePicker,
            subtitle: Text('$_currentSelectedDate'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tarea == null) {
                tareasModel tarea = tareasModel(
                    nomTarea: _controllerNomTarea.text,
                    dscTarea: _controllerDscTarea.text,
                    fechaEntrega: _currentSelectedDate,
                    entregada: "");
                _database.insert(tarea.toMap()).then((value) {
                  if (value > 0) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("La solicitud no se completo"),
                      ),
                    );
                  }
                });
              } else {
                tareasModel t = tareasModel(
                    idTarea: tarea.idTarea,
                    nomTarea: _controllerNomTarea.text,
                    dscTarea: _controllerDscTarea.text,
                    fechaEntrega: _currentSelectedDate,
                    entregada: "");
                _database.update(t.toMap()).then((value) {
                  if (value > 0) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("La solicitud no se completo"),
                      ),
                    );
                  }
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: tarea == null
                  ? [
                      Text(
                        "Crear tarea",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Icon(
                        Icons.add_circle,
                        size: 30,
                      ),
                    ]
                  : [
                      Text(
                        "Guardar tarea",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Icon(
                        Icons.save,
                        size: 30,
                      ),
                    ],
            ),
          )
        ],
      ),
    );
  }

  void datePicker() async {
    var selectedDate = await getDatePicker();
    setState(() {
      if (selectedDate == null) {
        _currentSelectedDate = new DateFormat.yMd().format(DateTime.now());
      } else
        _currentSelectedDate = new DateFormat.yMd().format(selectedDate);
    });
  }

  Future<DateTime?> getDatePicker() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
  }
}
