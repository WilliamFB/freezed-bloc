import 'package:bloc_studies/features/contacts_cubit/list/cubit/contacts_list_cubit_cubit.dart';
import 'package:bloc_studies/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../models/contact_model.dart';

class ContactsListCubitPage extends StatelessWidget {
  const ContactsListCubitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Cubit'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).pushNamed('cubit/contacts/register');
          context.read<ContactsListCubitCubit>().findAll();
        },
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
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return Column(
                            children: [
                              Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      flex: 1,
                                      autoClose: true,
                                      onPressed: (context) {
                                        context
                                            .read<ContactsListCubitCubit>()
                                            .delete(contact);
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete_forever,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(contact.name),
                                  subtitle: Text(contact.email),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey[300],
                              ),
                            ],
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
