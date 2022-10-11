// import 'package:bloc/bloc.dart';
import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/contact_model.dart';

part 'contacts_list_bloc.freezed.dart';
part 'contacts_list_event.dart';
part 'contacts_list_state.dart';

class ContactsListBloc extends Bloc<ContactsListEvent, ContactsListState> {
  final ContactsRepository _repository;

  ContactsListBloc({required ContactsRepository repository})
      : _repository = repository,
        super(ContactsListState.initial()) {
    on<_ContactsListEventFindAll>(_findAll);
    on<_ContactsListEventDelete>(_delete);
  }

  FutureOr<void> _findAll(
      _ContactsListEventFindAll event, Emitter<ContactsListState> emit) async {
    try {
      emit(ContactsListState.loading());
      final contacts = await _repository.findAll();
      await Future.delayed(const Duration(seconds: 2));
      emit(ContactsListState.data(contacts: contacts));
    } catch (e, s) {
      log('Erro ao buscar contatos', error: e, stackTrace: s);
      emit(ContactsListState.error(error: 'Erro ao buscar contatos'));
    }
  }

  FutureOr<void> _delete(
      _ContactsListEventDelete event, Emitter<ContactsListState> emit) async {
    try {
      emit(ContactsListState.loading());

      await _repository.delete(event.model);
      add(const _ContactsListEventFindAll());
    } catch (e, s) {
      log('Erro ao deletar contato', error: e, stackTrace: s);
      emit(ContactsListState.error(error: 'Erro ao deletar contato'));
    }
  }
}
