import 'package:bloc_studies/core/ui/scaffold_messenger_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/contact_model.dart';
import '../../../widgets/loader.dart';
import 'bloc/contacts_update_bloc.dart';

class ContactsUpdatePage extends StatefulWidget {
  final ContactModel contact;
  const ContactsUpdatePage({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactsUpdatePage> createState() => _ContactsUpdatePageState();
}

class _ContactsUpdatePageState extends State<ContactsUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEC;
  late final TextEditingController _emailEC;

  @override
  void initState() {
    super.initState();
    _nameEC = TextEditingController(text: widget.contact.name);
    _emailEC = TextEditingController(text: widget.contact.email);
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
        title: const Text('Update'),
      ),
      body: BlocListener<ContactsUpdateBloc, ContactsUpdateState>(
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
                  validator: (String? value) {
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
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo e-mail é obrigatório';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final validate = _formKey.currentState?.validate() ?? false;
                    if (validate) {
                      context
                          .read<ContactsUpdateBloc>()
                          .add(ContactsUpdateEvent.save(
                            id: widget.contact.id!,
                            name: _nameEC.text,
                            email: _emailEC.text,
                          ));
                    }
                  },
                  child: const Text('Salvar'),
                ),
                Loader<ContactsUpdateBloc, ContactsUpdateState>(
                  selector: (state) {
                    return state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
