import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_studies/models/contact_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../repositories/contacts_repository.dart';

part 'contacts_update_bloc.freezed.dart';
part 'contacts_update_event.dart';
part 'contacts_update_state.dart';

class ContactsUpdateBloc
    extends Bloc<ContactsUpdateEvent, ContactsUpdateState> {
  final ContactsRepository _repository;

  ContactsUpdateBloc({required ContactsRepository repository})
      : _repository = repository,
        super(const _Initial()) {
    on<_Save>(_save);
  }

  FutureOr<void> _save(_Save event, Emitter<ContactsUpdateState> emit) async {
    try {
      emit(const ContactsUpdateState.loading());
      final model = ContactModel(
        id: event.id,
        name: event.name,
        email: event.email,
      );
      await _repository.update(model);
      emit(const ContactsUpdateState.success());
    } catch (e, s) {
      log('Erro ao atualizar o contato', error: e, stackTrace: s);
      emit(
        const ContactsUpdateState.error(message: 'Erro ao atualizar contato.'),
      );
    }
  }
}
