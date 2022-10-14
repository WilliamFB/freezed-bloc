import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_studies/repositories/contacts_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/contact_model.dart';

part 'contacts_list_cubit_cubit.freezed.dart';
part 'contacts_list_cubit_state.dart';

class ContactsListCubitCubit extends Cubit<ContactsListCubitState> {
  final ContactsRepository _repository;

  ContactsListCubitCubit({required ContactsRepository repository})
      : _repository = repository,
        super(const ContactsListCubitState.initial());

  Future<void> findAll() async {
    try {
      emit(const ContactsListCubitState.loading());
      final contacts = await _repository.findAll();
      await Future.delayed(const Duration(seconds: 1));
      emit(ContactsListCubitState.data(contacts: contacts));
    } catch (e, s) {
      log('Erro ao buscar contatos', error: e, stackTrace: s);
      emit(const ContactsListCubitState.error(
          message: 'Erro ao buscar contatos'));
    }
  }

  Future<void> delete(ContactModel model) async {
    emit(const ContactsListCubitState.loading());
    await _repository.delete(model);
    await findAll();
  }
}
