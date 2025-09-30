import 'package:equatable/equatable.dart';

class SetProfileParams extends Equatable {
  final String securityCode;
  final String securityCodeConfirm;

  const SetProfileParams({
    required this.securityCode,
    required this.securityCodeConfirm,
  });

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    params['security_code'] = securityCode;
    params['security_code_confirmation'] = securityCodeConfirm;

    return params;
  }

  @override
  List<Object?> get props => [securityCode, securityCodeConfirm];

  @override
  String toString() {
    return 'SetProfileParams{securityCode: $securityCode, securityCodeConfirm: $securityCodeConfirm}';
  }
}
