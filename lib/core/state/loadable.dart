import 'package:equatable/equatable.dart';

sealed class Loadable<T> extends Equatable {
  const Loadable._(T? value) : _value = value;

  const factory Loadable.success(T data) = LoadableSuccess<T>;
  const factory Loadable.error(String? message, [T? previousValue]) =
      LoadableError<T>;
  const factory Loadable.empty() = LoadableEmpty<T>;
  const factory Loadable.loading([T? previousValue]) = LoadableLoading<T>;

  bool get isSuccess => this is LoadableSuccess;
  bool get isError => this is LoadableError;
  bool get isEmpty => this is LoadableEmpty;
  bool get isLoading => this is LoadableLoading;

  final T? _value;

  T get value {
    if (_value == null) {
      throw StateError('No value present');
    }
    return _value;
  }

  T? get valueOrNull => _value;
  T valueOrElse(T defaultValue) => _value ?? defaultValue;

  String? get errorMessage =>
      isError ? (this as LoadableError<T>).message : null;

  Loadable<T> toLoading() {
    return LoadableLoading(_value);
  }

  R when<R>({
    required R Function(T value) success,
    required R Function(String? message, T? previousValue) error,
    required R Function() empty,
    required R Function(T? previousValue) loading,
  }) {
    return switch (this) {
      LoadableSuccess() => success(_value as T),
      LoadableError(message: final m, valueOrNull: final v) => error(m, v),
      LoadableEmpty() => empty(),
      LoadableLoading(valueOrNull: final v) => loading(v),
    };
  }

  @override
  List<Object?> get props => [_value];
}

class LoadableSuccess<T> extends Loadable<T> {
  const LoadableSuccess(T super.value) : super._();
}

class LoadableError<T> extends Loadable<T> {
  final String? message;

  const LoadableError(this.message, [super.previousValue]) : super._();

  @override
  List<Object?> get props => [message, _value];
}

class LoadableEmpty<T> extends Loadable<T> {
  const LoadableEmpty() : super._(null);
}

class LoadableLoading<T> extends Loadable<T> {
  const LoadableLoading([super.previousValue]) : super._();

  LoadableLoading<T> withPreviousValue(T value) {
    return LoadableLoading(value);
  }
}
