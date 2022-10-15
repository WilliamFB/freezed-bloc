import 'package:bloc_studies/core/ui/scaffold_messenger_extension.dart';
import 'package:bloc_studies/features/contacts/register/bloc/contacts_register_bloc.dart';
import 'package:bloc_studies/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsRegisterPage extends StatefulWidget {
  const ContactsRegisterPage({Key? key}) : super(key: key);

  @override
  State<ContactsRegisterPage> createState() => _ContactsRegisterPageState();
}

class _ContactsRegisterPageState extends State<ContactsRegisterPage> {
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
        title: const Text('Register Bloc'),
      ),
      body: BlocListener<ContactsRegisterBloc, ContactsRegisterState>(
        // Não executa o listener quando for success e error
        listenWhen: (previous, current) {
          return current.maybeWhen(
            success: () => true,
            error: (_) => true,
            orElse: () => false,
          );
        },
        listener: (context, state) {
          // whenOrNull não tem orElse, então caso seja um estado diferente, nada acontece
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
                          .read<ContactsRegisterBloc>()
                          .add(ContactsRegisterEvent.save(
                            nome: _nameEC.text,
                            email: _emailEC.text,
                          ));
                    }
                  },
                  child: const Text('Salvar'),
                ),
                Loader<ContactsRegisterBloc, ContactsRegisterState>(
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
