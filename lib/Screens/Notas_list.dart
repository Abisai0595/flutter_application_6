import 'package:flutter/material.dart';
import 'package:flutter_application_6/Models/Notas.dart';
import 'package:flutter_application_6/Utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'Notas_detail.dart';

class Notaslist extends StatefulWidget {
  State<StatefulWidget> createState() {
    return Notasliststate();
  }
}

class Notasliststate extends State<Notaslist> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Notas> notasList = List<Notas>();
  int count = 0;

  Widget build(BuildContext context) {
    if (notasList == null) {
      notasList = List<Notas>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Notas')),
      body: getNotasListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigateToDetail(Notas('', '', ''), 'Agregar Nota');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNotasListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text('h'),
              ),
              title: Text(
                this.notasList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(this.notasList[position].date),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      _delete(context, notasList[position]);
                    },
                  )
                ],
              ),
              onTap: () {
                NavigateToDetail(this.notasList[position], 'Editar nota');
              },
            ),
          );
        });
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Notas notas) async {
    int result = await databaseHelper.deleteNotas(notas.id);
    if (result != 0) {
      _showSnackBar(context, 'Nota borrada con exito');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void NavigateToDetail(Notas notas, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Notasdetail(notas, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initalizeDatabase();
    dbFuture.then((dataBase) {
      Future<List<Notas>> notasListFuture = databaseHelper.getNotasList();
      notasListFuture.then((notasList) {
        setState(() {
          this.notasList = notasList;
          this.count = notasList.length;
        });
      });
    });
  }
}
