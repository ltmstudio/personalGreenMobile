import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String phoneNumber;
  final String session;
  final String code;

  const LoginParams({
    required this.phoneNumber,
    required this.session,
    required this.code,
  });

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    params['code'] = code;
    params['session'] = session;

    return params;
  }

  @override
  List<Object?> get props => [phoneNumber, session, code];
}
