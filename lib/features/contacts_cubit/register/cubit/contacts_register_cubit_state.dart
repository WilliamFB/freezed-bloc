part of 'contacts_register_cubit_cubit.dart';

@freezed
class ContactsRegisterCubitState with _$ContactsRegisterCubitState {
  const factory ContactsRegisterCubitState.initial() = _Initial;
  const factory ContactsRegisterCubitState.success() = _Success;
  const factory ContactsRegisterCubitState.loading() = _Loading;
  const factory ContactsRegisterCubitState.error({required String message}) =
      _Error;
}
