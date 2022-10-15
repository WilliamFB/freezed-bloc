import 'package:bloc_studies/features/contacts/list/contacts_list_page.dart';
import 'package:bloc_studies/features/contacts/register/bloc/contacts_register_bloc.dart';
import 'package:bloc_studies/features/contacts/register/contacts_register_page.dart';
import 'package:bloc_studies/features/contacts_cubit/list/contacts_list_cubit_page.dart';
import 'package:bloc_studies/features/contacts_cubit/list/cubit/contacts_list_cubit_cubit.dart';
import 'package:bloc_studies/features/contacts_cubit/register/contacts_register_cubit_page.dart';
import 'package:bloc_studies/features/contacts_cubit/register/cubit/contacts_register_cubit_cubit.dart';
import 'package:bloc_studies/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/contacts/list/bloc/contacts_list_bloc.dart';
import 'features/contacts/update/bloc/contacts_update_bloc.dart';
import 'features/contacts/update/contacts_update_page.dart';
import 'models/contact_model.dart';
import 'repositories/contacts_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ContactsRepository(),
      child: MaterialApp(
        title: 'Bloc & Cubit & Freezed',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          'bloc/contacts/list': (context) {
            return BlocProvider(
              create: (context) => ContactsListBloc(
                repository: context.read<ContactsRepository>(),
              )..add(const ContactsListEvent.findAll()),
              child: const ContactsListPage(),
            );
          },
          'bloc/contacts/register': (context) {
            return BlocProvider(
              create: (context) =>
                  ContactsRegisterBloc(repository: context.read()),
              child: const ContactsRegisterPage(),
            );
          },
          'bloc/contacts/update': (context) {
            final contact =
                ModalRoute.of(context)!.settings.arguments as ContactModel;

            return BlocProvider(
              create: (context) =>
                  ContactsUpdateBloc(repository: context.read()),
              child: ContactsUpdatePage(contact: contact),
            );
          },
          'cubit/contacts/list': (context) {
            return BlocProvider(
              create: (context) => ContactsListCubitCubit(
                repository: context.read(),
              )..findAll(),
              child: const ContactsListCubitPage(),
            );
          },
          'cubit/contacts/register': (context) {
            return BlocProvider(
              create: (context) =>
                  ContactsRegisterCubitCubit(repository: context.read()),
              child: const ContactsRegisterCubitPage(),
            );
          }
        },
      ),
    );
  }
}
