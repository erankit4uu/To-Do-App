import 'package:flutter/material.dart';
import 'package:to_do_app/model/to_do_item.dart';
import 'package:to_do_app/util/database_helper.dart';
import 'package:to_do_app/util/date_formatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();

  var db = new DatabaseHelper();

  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readToDOList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: Text(
                        _itemList[index].itemName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_itemList[index].dateCreated,
                          style: TextStyle(
                              color: Colors.white30,
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                      onLongPress: () => _update(_itemList[index], index),
                      trailing: new Listener(
                        key: Key(_itemList[index].itemName),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                            _deleteTodo(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),
          Divider(
            height: 5.0,
          )
        ],
      ),
    );
  }

  void _showDialogBox() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Item",
              hintText: "eg. Buy stuff",
              icon: Icon(Icons.note_add),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            handleSubmit(_textEditingController.text);
            _textEditingController.clear();
          },
          child: Text("Save"),
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  handleSubmit(String str) async {
    _textEditingController.clear();

    ToDoItem toDoItem = new ToDoItem(str, dateFormatter());
    int savedItemId = await db.saveItem(toDoItem);

    ToDoItem itemAdded = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, itemAdded);
    });
    Navigator.pop(context);

    print("Item Saved Id  $savedItemId");
  }

  _readToDOList() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _itemList.add(ToDoItem.map(item));
      });

//     ToDoItem toDoItem = ToDoItem.fromMap(item);
//     print("TO DO Items: ${toDoItem.itemName}");
    });
  }

  _deleteTodo(int id, int index) async{
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _update(ToDoItem itemList, int index) {
    var alert = AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "",
                  hintText: "eg. Buy stuff",
                  icon: Icon(Icons.note_add),
                ),
              ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            ToDoItem updateItem = new ToDoItem.fromMap(
              {"itemName" : _textEditingController.text,
              "dateCreated": dateFormatter(),
              "id": itemList.id}
            );
            submitUpdate(updateItem, index);
            await db.updateItem(updateItem);
            setState(() {
              _readToDOList();
            });
            Navigator.pop(context);
          },
          child: Text("Update"),
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void submitUpdate(ToDoItem updateItem, int index) {
    setState(() {
      _textEditingController.clear();
        _itemList.removeWhere((element){
          _itemList[index].itemName == updateItem.itemName;
        });
    });
  }
}
