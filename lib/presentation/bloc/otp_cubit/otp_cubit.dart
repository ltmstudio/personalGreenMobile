
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_dom/core/error/failure.dart';
import 'package:hub_dom/data/models/auth/otp_model.dart';
import 'package:hub_dom/data/repositories/auth/auth_repository.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this.repository) : super(OtpInitial());

final AuthenticationRepository repository;

  Future<void> sendOtp(int phoneNumber) async {
    emit(OtpLoading());
    final result = await repository.sendOtp(phoneNumber);
    result.fold(
      (failure) {
        if (failure is ConnectionFailure) {
          emit(OtpConnectionError());
        } else {
          emit(OtpError());
        }
      },
      (success) {
        emit(OtpLoaded(data: success));
      },
    );
  }

  initializeState() {
    emit(OtpInitial());
  }
}
