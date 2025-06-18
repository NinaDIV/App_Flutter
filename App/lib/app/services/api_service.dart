import 'dart:convert';
import 'package:MULTIAPP/app/model/user.dart';
import 'package:http/http.dart' as http;
 
 

Future<List<User>> fetchUsers() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((userJson) => User.fromJson(userJson)).toList();
  } else {
    throw Exception('Error al obtener usuarios');
  }
}
