class Notas {
  int _id;
  String _title;
  String _description;
  String _date;

  Notas(this._title, this._description, [this._date]);

  Notas.withId(this._id, this._title, this._description, [this._date]);

  //Obtenemos valores
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;

  //Ingresamos valores
  set title(String newtitle) {
    if (newtitle.length <= 225) {
      this._title = newtitle;
    }
  }

  set description(String newdesc) {
    if (newdesc.length <= 225) {
      this._description = newdesc;
    }
  }

  set date(String newdate) {
    this._date = newdate;
  }

//Map es una lista de pares clave donde el string es la clave
//Conversion de objeto notas a objeto Map
  toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
  }

//Extraer un Objeto de Nota de un Objeto Map
  Notas.fromMapObjects(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
  }
}
