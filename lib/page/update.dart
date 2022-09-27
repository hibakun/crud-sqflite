import 'package:crud_sqflite/database/db_helper.dart';
import 'package:crud_sqflite/model/makanan.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final Makanan makanan;

  const UpdatePage({Key? key, required this.makanan}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final DatabaseHelper _database = DatabaseHelper.instance;

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.makanan.id);
    print(widget.makanan.name);
    _nameController.text = widget.makanan.name ?? '';
    _categoryController.text = widget.makanan.category ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
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
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _database.update(
                        widget.makanan.id!,
                        Makanan(
                          name: _nameController.text,
                          category: _categoryController.text,
                        ));
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
