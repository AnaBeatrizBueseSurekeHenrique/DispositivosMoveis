import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PerenualService {
  final String _key = "sk-XKL768cc0fb9d1c1112444";
  //https://perenual.com/api/v2/species-list?key=sk-XKL768cc0fb9d1c1112444&q=lily

  Future<Map> getPlantsByName(String nome, int page) async {
    http.Response response;
    if (nome.isEmpty) {
      response = await http.get(
        Uri.parse(
          "https://perenual.com/api/v2/species-list?key=$_key&q=$nome&page=$page",
        ),
      );
    } else {
      response = await http.get(
        Uri.parse(
          "https://perenual.com/api/v2/species-list?key=$_key&page=$page",
        ),
      );
    }
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> doencasPlantas(String? nome) async {
    try {
      final uri = Uri.parse(
        "https://perenual.com/api/pest-disease-list?key=$_key&q=$nome",
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
