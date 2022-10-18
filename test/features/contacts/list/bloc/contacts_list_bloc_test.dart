import 'package:bloc_studies/features/contacts/list/bloc/contacts_list_bloc.dart';
import 'package:bloc_studies/models/contact_model.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  // Declaração
  late ContactsRepository repository;
  late ContactsListBloc bloc;
  late List<ContactModel> contacts;

  // Setup / Preparação
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

  // Execução
  blocTest<ContactsListBloc, ContactsListState>(
    'Deve buscar os contatos',
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactsListEvent.findAll()),
    setUp: () {
      when(
        () => repository.findAll(),
      ).thenAnswer((_) async => contacts);
    },
    expect: () => [
      ContactsListState.loading(),
      ContactsListState.data(contacts: contacts),
    ],
  );

  blocTest<ContactsListBloc, ContactsListState>(
    'Deve retornar erro ao buscar contatos',
    build: () => bloc,
    act: (bloc) => bloc.add(const ContactsListEvent.findAll()),
    expect: () => [
      ContactsListState.loading(),
      ContactsListState.error(error: 'Erro ao buscar contatos'),
    ],
  );
}
