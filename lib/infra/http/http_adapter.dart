import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter3_app/data/http/http_client.dart';
import 'package:flutter3_app/data/http/http_error.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map<dynamic, dynamic>?> request({
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
      try {
        Response response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonBody,
          encoding: null,
        );
        // debugPrint(response.body);

        switch (response.statusCode) {
          case 200:
            return response.body.isEmpty ? null : jsonDecode(response.body);
          case 204:
            return null;
          case 400:
            throw HttpError.badRequest;
          case 401:
            throw HttpError.unauthorized;
          case 403:
            throw HttpError.forbidden;
          case 404:
            throw HttpError.notFound;
          case 500:
            throw HttpError.serverError;
          default:
            throw Exception('Out of Exception - Check http_adapter');
        }
      } catch (e) {
        debugPrint('Deu mal');
        throw HttpError.serverError;
      }
    } else if (method == "get") {
      var response = await client.get(
        Uri.parse(url),
        headers: headers,
      );
      // debugPrint(response.body);
      return jsonDecode(response.body);
    }
    throw throw HttpError.serverError;
  }
}
