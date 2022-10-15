part of 'contacts_update_cubit_cubit.dart';

@freezed
class ContactsUpdateCubitState with _$ContactsUpdateCubitState {
  const factory ContactsUpdateCubitState.initial() = _Initial;
  const factory ContactsUpdateCubitState.loading() = _Loading;
  const factory ContactsUpdateCubitState.success() = _Success;
  const factory ContactsUpdateCubitState.error({required String message}) =
      _Error;
}
