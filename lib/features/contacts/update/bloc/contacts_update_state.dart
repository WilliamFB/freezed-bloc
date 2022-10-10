part of 'contacts_update_bloc.dart';

@freezed
class ContactsUpdateState with _$ContactsUpdateState {
  const factory ContactsUpdateState.initial() = _Initial;
  const factory ContactsUpdateState.loading() = _Loading;
  const factory ContactsUpdateState.error({required String message}) = _Error;
  const factory ContactsUpdateState.success() = _Success;
}
