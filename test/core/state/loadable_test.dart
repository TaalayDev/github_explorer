import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/core/state/loadable.dart';

void main() {
  test('exposes the state flags', () {
    expect(const Loadable<int>.success(1).isSuccess, isTrue);
    expect(const Loadable<int>.error('x').isError, isTrue);
    expect(const Loadable<int>.empty().isEmpty, isTrue);
    expect(const Loadable<int>.loading().isLoading, isTrue);
  });

  test('keeps the previous value while loading and on error', () {
    expect(const Loadable.success(1).toLoading().valueOrNull, 1);
    expect(const Loadable<int>.error('x', 2).valueOrNull, 2);
    expect(const Loadable<int>.loading(3).value, 3);
  });

  test('value throws when nothing is present', () {
    expect(() => const Loadable<int>.empty().value, throwsStateError);
    expect(const Loadable<int>.empty().valueOrElse(5), 5);
  });

  test('exposes the error message only for errors', () {
    expect(const Loadable<int>.error('boom').errorMessage, 'boom');
    expect(const Loadable<int>.success(1).errorMessage, isNull);
  });

  test('when dispatches to the matching branch', () {
    String describe(Loadable<int> loadable) => loadable.when(
      success: (value) => 'success $value',
      error: (message, previous) => 'error $message $previous',
      empty: () => 'empty',
      loading: (previous) => 'loading $previous',
    );

    expect(describe(const Loadable.success(1)), 'success 1');
    expect(describe(const Loadable.error('x', 2)), 'error x 2');
    expect(describe(const Loadable.empty()), 'empty');
    expect(describe(const Loadable.loading(3)), 'loading 3');
  });

  test('compares by state and value', () {
    expect(const Loadable.success(1), const Loadable.success(1));
    expect(const Loadable.success(1), isNot(const Loadable.success(2)));
    expect(
      const Loadable<int>.error('a'),
      isNot(const Loadable<int>.error("b")),
    );
    expect(const Loadable<int>.loading(), isNot(const Loadable<int>.empty()));
  });
}
