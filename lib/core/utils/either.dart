// lib/core/utils/either.dart
abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight);

  bool get isLeft;
  bool get isRight;
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight) => ifLeft(value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L) ifLeft, T Function(R) ifRight) => ifRight(value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;
}
