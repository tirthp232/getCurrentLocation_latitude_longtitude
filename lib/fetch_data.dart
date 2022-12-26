import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maplocation/model.dart';

class FetchData {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  Future<List<Model>> fetchData() async {
    var res = await http.get(url);

    List<dynamic> resbody = jsonDecode(res.body);

    List<Model> data = [];
    for (int i = 0; i < resbody.length; i++) {
      data.add(Model(
        id: resbody[i]['id'],
        name: resbody[i]['name'],
        username: resbody[i]['username'],
        email: resbody[i]['email'],
        address: resbody[i]['address'],
        phone: resbody[i]['phone'],
        website: resbody[i]['website'],
        company: resbody[i]['company'],
      ));
    }

    return data;
  }
}
