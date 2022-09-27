import 'package:crud_sqflite/database/db_helper.dart';
import 'package:crud_sqflite/model/makanan.dart';
import 'package:flutter/material.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({Key? key}) : super(key: key);

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final DatabaseHelper _database = DatabaseHelper.instance;

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nama makanan"),
              TextFormField(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Nama makanan wajib diisi";
                  } else if (value.length < 2) {
                    return "Nama makanan harus lebih dari 1 karakter";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Category"),
              TextFormField(
                controller: _categoryController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Category wajib diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 35,
              ),
              Center(
                child: SizedBox(
                  width: size.width / 2,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _database.insert(Makanan(
                            name: _nameController.text,
                            category: _categoryController.text));
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
