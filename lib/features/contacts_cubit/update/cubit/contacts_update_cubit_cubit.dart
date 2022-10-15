import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/contact_model.dart';

part 'contacts_update_cubit_cubit.freezed.dart';
part 'contacts_update_cubit_state.dart';

class ContactsUpdateCubitCubit extends Cubit<ContactsUpdateCubitState> {
  final ContactsRepository _repository;

  ContactsUpdateCubitCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactsUpdateCubitState.initial());

  Future<void> update(ContactModel contact) async {
    try {
      emit(const ContactsUpdateCubitState.loading());
      await Future.delayed(const Duration(seconds: 1));
      await _repository.update(contact);
      emit(const ContactsUpdateCubitState.success());
    } catch (e, s) {
      log('Erro ao atualizar contato', error: e, stackTrace: s);
      emit(const ContactsUpdateCubitState.error(
          message: 'Erro ao atualizar contato'));
    }
  }
}
