import 'package:bloc_studies/features/contacts_cubit/list/cubit/contacts_list_cubit_cubit.dart';
import 'package:bloc_studies/models/contact_model.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockContactsRepository extends Mock implements ContactsRepository {}

void main() {
  // Declaração
  late ContactsRepository repository;
  late ContactsListCubitCubit cubit;
  late List<ContactModel> contacts;

  // Setup / Preparação
  setUp(
    () {
      repository = MockContactsRepository();
      cubit = ContactsListCubitCubit(repository: repository);
      contacts = [
        ContactModel(name: 'name1', email: 'email1'),
        ContactModel(name: 'name2', email: 'email2'),
      ];
    },
  );

  blocTest<ContactsListCubitCubit, ContactsListCubitState>(
    'Deve buscar os contatos',
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    setUp: () {
      when(
        () => repository.findAll(),
      ).thenAnswer((_) async => contacts);
    },
    expect: () => [
      const ContactsListCubitState.loading(),
      ContactsListCubitState.data(contacts: contacts),
    ],
  );

  blocTest<ContactsListCubitCubit, ContactsListCubitState>(
    'Deve retornar erro ao buscar contatos',
    build: () => cubit,
    act: (cubit) => cubit.findAll(),
    expect: () => [
      const ContactsListCubitState.loading(),
      const ContactsListCubitState.error(message: 'Erro ao buscar contatos'),
    ],
  );
}
