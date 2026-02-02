import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_app/model/pet_model.dart';

class ApiService {
  final String apiUrl =
      "https://jatinderji.github.io/users_pets_api/users_pets.json";

  Future<List<Data>> fetchPets() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Data.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }
}
