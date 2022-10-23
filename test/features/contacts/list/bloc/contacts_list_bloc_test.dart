import 'package:bloc_studies/features/contacts/list/bloc/contacts_list_bloc.dart';
import 'package:bloc_studies/models/contact_model.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  late ContactsRepository repository;
  late ContactsListBloc bloc;
  late List<ContactModel> contacts;

  setUp(
    () {
      repository = MockContactsRepository();
      bloc = ContactsListBloc(repository: repository);
      contacts = [
        ContactModel(name: 'name1', email: 'email1'),
        ContactModel(name: 'name2', email: 'email2'),
      ];
    },
  );

  group('Repository sem erros', () {
    setUp(
      () {
        when(
          () => repository.findAll(),
        ).thenAnswer((_) async => contacts);
        when(
          () => repository.delete(contacts[0]),
        ).thenAnswer((_) async => {});
      },
    );

    blocTest<ContactsListBloc, ContactsListState>(
      'Deve buscar os contatos',
      build: () => bloc,
      act: (bloc) => bloc.add(const ContactsListEvent.findAll()),
      expect: () => [
        ContactsListState.loading(),
        ContactsListState.data(contacts: contacts),
      ],
    );

    blocTest<ContactsListBloc, ContactsListState>(
      'Deve atualizar os contatos após o delete',
      build: () => bloc,
      act: (bloc) => bloc.add(ContactsListEvent.delete(model: contacts[0])),
      expect: () => [
        ContactsListState.loading(),
        ContactsListState.data(contacts: contacts),
      ],
    );
  });

  group('Repository com erros', () {
    blocTest<ContactsListBloc, ContactsListState>(
      'Deve retornar erro ao buscar contatos',
      build: () => bloc,
      act: (bloc) => bloc.add(const ContactsListEvent.findAll()),
      expect: () => [
        ContactsListState.loading(),
        ContactsListState.error(error: 'Erro ao buscar contatos'),
      ],
    );

    blocTest<ContactsListBloc, ContactsListState>(
      'Deve retornar erro ao deletar',
      build: () => bloc,
      act: (bloc) => bloc.add(ContactsListEvent.delete(model: contacts[0])),
      expect: () => [
        ContactsListState.loading(),
        ContactsListState.error(error: 'Erro ao deletar contato'),
      ],
    );
  });
}
