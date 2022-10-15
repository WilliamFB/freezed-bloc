import 'package:bloc_studies/core/ui/scaffold_messenger_extension.dart';
import 'package:bloc_studies/features/contacts_cubit/register/cubit/contacts_register_cubit_cubit.dart';
import 'package:bloc_studies/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsRegisterCubitPage extends StatefulWidget {
  const ContactsRegisterCubitPage({Key? key}) : super(key: key);

  @override
  State<ContactsRegisterCubitPage> createState() =>
      _ContactsRegisterCubitPageState();
}

class _ContactsRegisterCubitPageState extends State<ContactsRegisterCubitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();

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
        title: const Text('Register Cubit'),
      ),
      body:
          BlocListener<ContactsRegisterCubitCubit, ContactsRegisterCubitState>(
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
                          name: _nameEC.text, email: _emailEC.text);
                      context
                          .read<ContactsRegisterCubitCubit>()
                          .register(contact);
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
