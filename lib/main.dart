import 'package:flutter/material.dart';
import 'package:practica3/src/screens/agregar_tarea_screen.dart';
import 'package:practica3/src/screens/listado_tareas_screen.dart';
import 'package:practica3/src/screens/tareas_entregadas_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/tareas': (BuildContext context) => TareasScreen(),
        '/agregartarea': (BuildContext context) => agregarTareaScreen(),
        '/entregadas': (BuildContext context) => tareasEntregadasScreen(),
      },
      home: TareasScreen(),
      debugShowCheckedModeBanner:
          false, //no mostrar la etique ta "Debug" en las pantallas de la aplicacion
    );
  }
}
