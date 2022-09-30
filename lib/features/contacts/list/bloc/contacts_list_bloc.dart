// import 'package:bloc/bloc.dart';
import 'dart:async';

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
  }

  FutureOr<void> _findAll(
      _ContactsListEventFindAll event, Emitter<ContactsListState> emit) async {
    final contacts = await _repository.findAll();
    emit(ContactsListState.data(contacts: contacts));
  }
}
