import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  int _id;

  ToDoItem(this._itemName, this._dateCreated);

  ToDoItem.map(dynamic obj) {
    this._itemName = obj['itemName'];
    this._dateCreated = obj['dateCreated'];
    this._id = obj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;

    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }

  ToDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  String get itemName => _itemName;

  String get dateCreated => _dateCreated;

  int get id => _id;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _itemName,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text("Created on : $_dateCreated"
            ,style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic
              )
              ,)
          )
        ],
      ),
    );
  }
}
