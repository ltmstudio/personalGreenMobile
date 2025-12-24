import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/usecase/addresses/get_contact_usecase.dart';
import 'package:hub_dom/core/usecase/usecase.dart';
import 'package:hub_dom/data/models/contacts_model.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase _getContactsUseCase;

  ContactsCubit(this._getContactsUseCase) : super(const ContactsInitial());

  Future<void> loadContacts() async {
    emit(const ContactsLoading());

    final result = await _getContactsUseCase.execute(NoParams());

    result.fold(
          (failure) => emit(ContactsError(failure.message)),
          (data) => emit(ContactsLoaded(data)),
    );
  }
}
