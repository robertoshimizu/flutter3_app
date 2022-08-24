import 'dart:convert';

import 'package:flutter3_app/data/http/http_client.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map<dynamic, dynamic>?>? request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json"
    };

    // Notar que o tratamento de erros só retorna o body, e não o status code.
    // É importante mapear todos os casos e como quer que o front end exiba a informação
    final jsonBody = body != null ? jsonEncode(body) : null;

    if (method == "post") {
      Response response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonBody,
        encoding: null,
      );
      // debugPrint(response.body);
      if (response.statusCode == 200) {
        return response.body.isEmpty ? null : jsonDecode(response.body);
      } else {
        return null;
      }
    }
    if (method == "get") {
      var response = await client.get(
        Uri.parse(url),
        headers: headers,
      );
      // debugPrint(response.body);
      return jsonDecode(response.body);
    }
  }
}
