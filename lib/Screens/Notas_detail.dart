import 'package:flutter/material.dart';
import 'package:flutter_application_6/Models/Notas.dart';
import 'package:flutter_application_6/Utils/database_helper.dart';
import 'package:intl/intl.dart';

class Notasdetail extends StatefulWidget {
  final String appbartitle;
  final Notas notas;

  Notasdetail(this.notas, this.appbartitle);
  State<StatefulWidget> createState() {
    return Notas_detail_state(this.notas, this.appbartitle);
  }
}

class Notas_detail_state extends State<Notasdetail> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  String appBarTitle;
  Notas notas;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Notas_detail_state(this.notas, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = notas.title;
    descriptionController.text = notas.description;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('ingreso titulo');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Titulo',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('ingreso descripcion');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Descripcion',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Guardar', textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            debugPrint('boton de guardado precionado' +
                                descriptionController.text +
                                titleController.text);
                            _save();
                          });
                        },
                      ),
                    ),
                    Container(width: 5),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Eliminar', textScaleFactor: 1.5),
                        onPressed: () {
                          setState(() {
                            debugPrint('boton de eliminar precionado');
                            _delete();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    notas.title = titleController.text;
  }

  void updateDescription() {
    notas.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    notas.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if (notas.id != null) {
      result = await databaseHelper.updateNotas(notas);
    } else {
      result = await databaseHelper.insertNotas(notas);
    }

    if (result != 0) {
      _showAlertDialog('Estatus', 'Nota guardada con exito');
    } else {
      _showAlertDialog('Estatus', 'Problema al guardar nota');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (notas.id == null) {
      _showAlertDialog('Estatus', 'no se a podido borrar ');
    }

    int result = await databaseHelper.deleteNotas(notas.id);
    if (result != 0) {
      _showAlertDialog('Estatus', 'Nota eliminada con exito');
    } else {
      _showAlertDialog('Estatus', 'Problema al borrar nota');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
