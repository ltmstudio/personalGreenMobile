import 'package:dartz/dartz.dart';

import '../error/failure.dart';

abstract class BaseUseCase<Input, Output> {
  Future<Either<Failure, Output>> execute(Input input);
}

class NoParams {}
