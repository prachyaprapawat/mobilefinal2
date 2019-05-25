import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Todo>> fetchTodos(int userid) async {
  final response = await http.get('https://jsonplaceholder.typicode.com/todos?');
  List<Todo> todoApi = [];
  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var todo = Todo.fromJson(body[i]);
 Text(todo.completed+'---------------');
      if( todo.userid == userid){
           todoApi.add(todo);
        Text(todo.completed+'---------------');
      }
    }
    return todoApi;
  } else {
    throw Exception('Failed to load post');
  }
}


class Todo {
  
  final int userid;
  final int id;
  final int name;
  final String title;
  final String completed;

  Todo({this.userid, this.id, this.title, this.completed, this.name});

  factory Todo.fromJson(Map<String, dynamic> json) {
      return Todo(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: (json['completed'] ? "complete" : ""),
    );
  }
}

class TodoPage extends StatelessWidget {
  // Declare a field that holds the Todo
   final int id;
   final String name;
  // In the constructor, require a Todo
  TodoPage({Key key, @required this.id,@required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("                                          BACK                                        "),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FutureBuilder(
              future: fetchTodos(this.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError){
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      // if( todo.completed == true)
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
            
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Todo> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: InkWell(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //  Todo().completed == true? 
                Text(
                  (values[index].id).toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                Text(
                  values[index].title,
                  style: TextStyle(fontSize: 16),
                ),
                Padding(padding: EdgeInsets.all(10),),
                Text(
                  values[index].completed,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }

}