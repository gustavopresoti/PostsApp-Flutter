import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";

  late List data;

  @override
  void initState() {
    super.initState();
    this.fetchData();
  }

  Future<String> fetchData() async {
    var response = await http.get(
        Uri.parse(apiUrl),
        headers: { "Accept": "application/json"}
    );

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson;
    });

    return "Success";
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Posts"),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder<String>(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) {
              return new ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    child: new Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(data[index]['title']),
                          subtitle: Text(data[index]['body']),
                          contentPadding: const EdgeInsets.all(10.0),
                          onTap:() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostPage(
                                  title: data[index]['title'],
                                  body: data[index]['body'],
                                )),
                            );
                          }
                        )
                      ],
                    ),
                  );
                },
              );
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class PostPage extends StatelessWidget {
  final String title;
  final String body;

  PostPage({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Wrap(
          runSpacing: 20.0,
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$body',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      )
    );
  }
}