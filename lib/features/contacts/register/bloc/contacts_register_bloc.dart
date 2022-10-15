import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_studies/models/contact_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../repositories/contacts_repository.dart';

part 'contacts_register_bloc.freezed.dart';
part 'contacts_register_event.dart';
part 'contacts_register_state.dart';

class ContactsRegisterBloc
    extends Bloc<ContactsRegisterEvent, ContactsRegisterState> {
  final ContactsRepository _repository;

  ContactsRegisterBloc({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactsRegisterState.initial()) {
    on<_Save>(_save);
  }

  FutureOr<void> _save(_Save event, Emitter<ContactsRegisterState> emit) async {
    try {
      emit(const ContactsRegisterState.loading());
      await Future.delayed(const Duration(seconds: 1));
      final contactModel = ContactModel(name: event.nome, email: event.email);
      await _repository.create(contactModel);
      emit(const ContactsRegisterState.success());
    } catch (e, s) {
      log('Erro ao salvar contato', error: e, stackTrace: s);
      emit(
        const ContactsRegisterState.error(message: 'Erro ao salvar contato.'),
      );
    }
  }
}
