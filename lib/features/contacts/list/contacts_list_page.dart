import 'package:bloc_studies/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../models/contact_model.dart';
import 'bloc/contacts_list_bloc.dart';

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, 'contacts/register');
          context
              .read<ContactsListBloc>()
              .add(const ContactsListEvent.findAll());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      body: BlocListener<ContactsListBloc, ContactsListState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            error: (error) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          state.whenOrNull(
            error: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: RefreshIndicator(
          onRefresh: () async => context.read<ContactsListBloc>()
            ..add(const ContactsListEvent.findAll()),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Column(
                  children: [
                    Loader<ContactsListBloc, ContactsListState>(
                      selector: (state) {
                        return state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                      },
                    ),
                    BlocSelector<ContactsListBloc, ContactsListState,
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
                                          context.read<ContactsListBloc>().add(
                                                ContactsListEvent.delete(
                                                  model: contact,
                                                ),
                                              );
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete_forever,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        'contacts/update',
                                        arguments: contact,
                                      );
                                      context.read<ContactsListBloc>().add(
                                          const ContactsListEvent.findAll());
                                    },
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
