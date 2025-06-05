import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  TextEditingController nameController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Name")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Ingrese el nuevo nombre",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await addPeople(nameController.text).then(() {
                  Navigator.pop(context);
                } as FutureOr Function(void value));
              },
              child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}