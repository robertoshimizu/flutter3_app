import '../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteAccountModel {
  final String token;
  final String name;

  RemoteAccountModel(this.name, this.token);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['name'], json['accessToken']);
  }
  AccountEntity toEntity() => AccountEntity(name, token);
}
