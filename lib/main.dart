import 'package:flutter/material.dart';
import 'package:maplocation/fetch_data.dart';
import 'package:maplocation/profile_screen.dart';

import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fd = FetchData();
  List<Model> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    data = await fd.fetchData();
    setState(() {});
    // print(data.length);
  }

  move(Model index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProfileScreen(model: index),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => move(data[index]),
            title: Text(data[index].name),
            subtitle: Text(data[index].email),
          );
        },
      ),
    );
  }
}
