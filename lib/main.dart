import 'package:flutter/material.dart';
import 'package:to_do_app/ui/to_do_screen.dart';

void main() {
  runApp(MaterialApp(
    title: "To-Do APP",
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do'),
        backgroundColor: Colors.grey.shade700,
      ),
      backgroundColor: Colors.black54,
      body: ToDoScreen(),
    );
  }
}


