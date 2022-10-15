import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/contact_model.dart';

part 'contacts_register_cubit_cubit.freezed.dart';
part 'contacts_register_cubit_state.dart';

class ContactsRegisterCubitCubit extends Cubit<ContactsRegisterCubitState> {
  final ContactsRepository _repository;

  ContactsRegisterCubitCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactsRegisterCubitState.initial());

  Future<void> register(ContactModel contact) async {
    try {
      emit(const ContactsRegisterCubitState.loading());
      await Future.delayed(const Duration(seconds: 1));
      await _repository.create(contact);
      emit(const ContactsRegisterCubitState.success());
    } catch (e, s) {
      log('Erro ao registrar contato', error: e, stackTrace: s);
      emit(const ContactsRegisterCubitState.error(
          message: 'Erro ao registrar contato'));
    }
  }
}
