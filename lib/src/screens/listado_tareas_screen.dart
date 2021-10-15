import 'package:flutter/material.dart';

class TareasScreen extends StatefulWidget {
  TareasScreen({Key? key}) : super(key: key);

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tareas pendientes"),
      ),
    );
  }
}
