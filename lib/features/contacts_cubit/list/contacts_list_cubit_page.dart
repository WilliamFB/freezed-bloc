import 'package:bloc_studies/features/contacts_cubit/list/cubit/contacts_list_cubit_cubit.dart';
import 'package:bloc_studies/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/contact_model.dart';

class ContactsListCubitPage extends StatelessWidget {
  const ContactsListCubitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Cubit'),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ContactsListCubitCubit>().findAll(),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  Loader<ContactsListCubitCubit, ContactsListCubitState>(
                    selector: (state) {
                      return state.maybeWhen(
                        orElse: () => false,
                        loading: () => true,
                      );
                    },
                  ),
                  BlocSelector<ContactsListCubitCubit, ContactsListCubitState,
                      List<ContactModel>>(
                    selector: (state) {
                      return state.maybeWhen(
                        data: (contacts) => contacts,
                        orElse: () => [],
                      );
                    },
                    builder: (_, contacts) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contacts.length,
                        itemBuilder: (_, index) {
                          final contact = contacts[index];
                          return ListTile(
                            title: Text(contact.name),
                            subtitle: Text(contact.email),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
