import 'package:bloc_studies/core/ui/scaffold_messenger_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/contact_model.dart';
import '../../../widgets/loader.dart';
import 'cubit/contacts_update_cubit_cubit.dart';

class ContactsUpdateCubitPage extends StatefulWidget {
  ContactModel contact;
  ContactsUpdateCubitPage({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactsUpdateCubitPage> createState() =>
      _ContactsUpdateCubitPageState();
}

class _ContactsUpdateCubitPageState extends State<ContactsUpdateCubitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();

  @override
  void initState() {
    _nameEC.text = widget.contact.name;
    _emailEC.text = widget.contact.email;
    super.initState();
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Cubit'),
      ),
      body: BlocListener<ContactsUpdateCubitCubit, ContactsUpdateCubitState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            success: () => true,
            error: (_) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          state.whenOrNull(
            success: () => Navigator.of(context).pop(),
            error: (message) => context.showErrorSnackbar(message),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameEC,
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo nome é obrigatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailEC,
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo e-mail é obrigatório';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final validated =
                        _formKey.currentState?.validate() ?? false;
                    if (validated) {
                      final contact = ContactModel(
                        id: widget.contact.id,
                        name: _nameEC.text,
                        email: _emailEC.text,
                      );
                      context.read<ContactsUpdateCubitCubit>().update(contact);
                    }
                  },
                  child: const Text('Salvar'),
                ),
                Loader<ContactsUpdateCubitCubit, ContactsUpdateCubitState>(
                  selector: (state) {
                    return state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
