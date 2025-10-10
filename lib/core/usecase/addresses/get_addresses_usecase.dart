import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/usecase/usecase.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/data/repositories/addresses/addresses_repository.dart';

class GetAddressesUseCase
    implements BaseUseCase<NoParams, AddressesResponseModel> {
  final AddressesRepository _repository;

  GetAddressesUseCase(this._repository);

  @override
  Future<Either<Failure, AddressesResponseModel>> execute(
    NoParams input,
  ) async {
    return await _repository.getAddresses();
  }
}
