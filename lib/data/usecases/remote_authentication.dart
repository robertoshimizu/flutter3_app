import 'package:equatable/equatable.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void>? auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams extends Equatable {
  late String email;
  late String password;

  RemoteAuthenticationParams(this.email, this.password);

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(params.email, params.password);

  Map toJson() => {'email': email, 'password': password};

  String get mail {
    return email;
  }

  String get secret {
    return password;
  }

  set setEmail(String email) {
    email = email;
  }

  set setPassword(String password) {
    password = password;
  }

  @override
  List get props => [email, password];
}
