import 'package:bloc_studies/models/contact_model.dart';
import 'package:dio/dio.dart';

class ContactsRepository {
  final url = 'http://10.0.2.2:3031/contacts';

  Future<List<ContactModel>> findAll() async {
    final response = await Dio().get(url);

    return response.data
        ?.map<ContactModel>((contact) => ContactModel.fromMap(contact))
        .toList();
  }

  Future<void> create(ContactModel model) async =>
      Dio().post(url, data: model.toMap());

  Future<void> update(ContactModel model) =>
      Dio().put('$url/${model.id}', data: model.toMap());

  Future<void> delete(ContactModel model) => Dio().delete('$url/%{model.id}');
}
