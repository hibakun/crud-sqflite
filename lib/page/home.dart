import 'package:crud_sqflite/database/db_helper.dart';
import 'package:crud_sqflite/model/makanan.dart';
import 'package:crud_sqflite/page/update.dart';
import 'package:flutter/material.dart';
import 'insert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _database = DatabaseHelper.instance;

  Future _initDb() async {
    await _database.database;
    setState(() {});
  }

  Future _delete(int id) async {
    await _database.delete(id);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite Sekolah'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsertPage(),
                ),
              ).then((value) => setState(() {}));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Makanan>>(
        future: _database.queryAll(),
        builder: (context, snapshot) {
          var connection = snapshot.connectionState;

          switch (connection) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Data masih kosong'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(snapshot.data![index].name ?? 'Empty'),
                        subtitle:
                            Text(snapshot.data![index].category ?? 'Empty'),
                        tileColor: Colors.white,
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (result) {
                            switch (result) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdatePage(
                                      makanan: snapshot.data![index],
                                    ),
                                  ),
                                ).then((value) => setState(() {}));
                                break;
                              case 1:
                                _delete(snapshot.data![index].id!);
                                break;
                            }
                          },
                          itemBuilder: (context) => <PopupMenuEntry>[
                            const PopupMenuItem(
                              value: 0,
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Hapus'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('Tidak ada data'),
                );
              }
            default:
              return const Center(
                child: Text('Tidak ada data (Default)'),
              );
          }
        },
      ),
    );
  }
}
