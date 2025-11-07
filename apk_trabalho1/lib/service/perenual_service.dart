import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PerenualService {
  final String _key = "";

  Future<Map> getPlantsByName(String nome, int page) async {
    try {
      final uri = Uri.parse(
        "https://perenual.com/api/v2/species-list?key=$_key&q=$nome&page=$page",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map> getPlantById(int id) async {
    try {
      final uri = Uri.parse(
        "https://perenual.com/api/v2/species/details/$id?key=$_key",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }
}
