import 'package:faker/faker.dart';
import 'package:flutter3_app/data/http/http.dart';
import 'package:flutter3_app/data/usecases/usecases.dart';
import 'package:flutter3_app/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late String email;
  late String password;
  late AuthenticationParams authenticationParams;

  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();
    authenticationParams = AuthenticationParams(email, password);

    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test('Should call Http Client with correct url', () async {
    await sut.auth(authenticationParams);

    final body =
        RemoteAuthenticationParams.fromDomain(authenticationParams).toJson();

    verify(httpClient.request(url: url, method: 'post', body: body));
  });
}
