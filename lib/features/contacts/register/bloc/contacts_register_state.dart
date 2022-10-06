part of 'contacts_register_bloc.dart';

@freezed
class ContactsRegisterState with _$ContactsRegisterState {
  const factory ContactsRegisterState.initial() = _Initial;
  const factory ContactsRegisterState.loading() = _Loading;
  const factory ContactsRegisterState.success() = _Success;
  const factory ContactsRegisterState.error({required String message}) = _Error;
}
