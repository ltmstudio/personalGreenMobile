import 'package:dartz/dartz.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/core/usecase/usecase.dart';
import 'package:hub_dom/data/models/addresses/addresses_response_model.dart';
import 'package:hub_dom/data/repositories/addresses/addresses_repository.dart';
import 'package:hub_dom/presentation/bloc/addresses/addresses_bloc.dart';

class GetAddressesUseCase
    implements BaseUseCase<AddressParams, AddressesResponseModel> {
  final AddressesRepository _repository;

  GetAddressesUseCase(this._repository);

  @override
  Future<Either<Failure, AddressesResponseModel>> execute(
      AddressParams input,
  ) async {
    return await _repository.getAddresses(input);
  }
}

class AddressParams {
  final int page;
  final String? search;

  AddressParams({required this.page, this.search});

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    params['page'] = page;
    params['term'] = search;
    params['with_statistics'] = 1;
    params['per_page'] = 30;

    return params;
  }
}

