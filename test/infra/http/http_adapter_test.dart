import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './http_adapter_test.mocks.dart' as mocks;

class HttpAdapter {
  final http.Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json"
    };
    if (method == "post") {
      await client.post(
        Uri.parse(url),
        headers: headers,
        body: null,
        encoding: null,
      );
    }
    if (method == "get") {
      await client.get(
        Uri.parse(url),
        headers: headers,
      );
    }
  }
}

@GenerateMocks([http.Client])
void main() {
  late mocks.MockClient client;
  late HttpAdapter sut;
  late String url;

  setUp(() {
    client = mocks.MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', (() {
    test('Should call post request with correct values', () async {
      // Stub
      when(client.post(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        },
        body: null,
        encoding: null,
      )).thenAnswer((_) async => http.Response(
          '{"accessToken": ${faker.guid.guid()}, "name": ${faker.person.name()}}',
          200));

      await sut.request(url: url, method: 'post');
    });

    test('get request', () async {
      when(client.get(Uri.parse(url), headers: {
        "content-type": "application/json",
        "accept": "application/json"
      })).thenAnswer((_) async =>
          http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      await sut.request(url: url, method: 'get');
    });
  }));
}
