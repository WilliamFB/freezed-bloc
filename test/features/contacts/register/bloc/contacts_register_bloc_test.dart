import 'package:bloc_studies/features/contacts/register/bloc/contacts_register_bloc.dart';
import 'package:bloc_studies/models/contact_model.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late ContactsRepository repository;
  late ContactsRegisterBloc bloc;
  late ContactModel contact;

  setUp(
    () {
      repository = MockContactsRepository();
      bloc = ContactsRegisterBloc(repository: repository);
      contact = ContactModel(name: 'name1', email: 'email1');
      registerFallbackValue(contact);
      when(
        () => repository.create(any()),
      ).thenAnswer((_) async => _);
    },
  );

  blocTest<ContactsRegisterBloc, ContactsRegisterState>(
    'Deve salvar o contato corretamente.',
    build: () => bloc,
    act: (bloc) => bloc.add(
      ContactsRegisterEvent.save(
        nome: contact.name,
        email: contact.email,
      ),
    ),
    expect: () => [
      const ContactsRegisterState.loading(),
      const ContactsRegisterState.success(),
    ],
  );
}
