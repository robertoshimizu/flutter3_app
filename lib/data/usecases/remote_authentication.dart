import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter3_app/domain/entities/entities.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../models/models.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity>? auth(AuthenticationParams params) async {
    // debugPrint('Qual email? ' + params.email);
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse!).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
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
