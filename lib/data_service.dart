import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class DataService {
  // factType: 'today' or 'random'
  Future<UselessFactsResponse> getUselessFacts(String factType) async {
    final queryParameters = {'language': 'en'};
    final uri =
        Uri.https('uselessfacts.jsph.pl', '/$factType.json', queryParameters);

    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    return UselessFactsResponse.fromJson(json);
  }
}
