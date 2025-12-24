import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/usecase/usecase.dart';
import 'package:hub_dom/data/models/contacts_model.dart';
import 'package:hub_dom/data/repositories/addresses/addresses_repository.dart';

class GetContactsUseCase implements BaseUseCase<NoParams, List<ContactsModel>> {
  final AddressesRepository _repository;

  GetContactsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ContactsModel>>> execute(NoParams input) async {
    return await _repository.getContacts();
  }
}
