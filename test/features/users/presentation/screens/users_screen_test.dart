import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_explorer/config/theme/theme.dart';
import 'package:github_explorer/core/errors/app_exception.dart';
import 'package:github_explorer/features/users/presentation/bloc/users_bloc.dart';
import 'package:github_explorer/features/users/presentation/bloc/users_event.dart';
import 'package:github_explorer/features/users/presentation/bloc/users_state.dart';
import 'package:github_explorer/features/users/presentation/screens/users_screen.dart';
import 'package:github_explorer/l10n/app_localizations.dart';
import 'package:github_explorer/shared/bloc/connectivity_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersBloc extends MockBloc<UsersEvent, UsersState>
    implements UsersBloc {}

class _MockConnectivityCubit extends MockCubit<bool>
    implements ConnectivityCubit {}

void main() {
  late _MockUsersBloc usersBloc;
  late _MockConnectivityCubit connectivityCubit;

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() {
    usersBloc = _MockUsersBloc();
    connectivityCubit = _MockConnectivityCubit();
    when(() => connectivityCubit.state).thenReturn(true);
  });

  Future<void> pumpScreen(WidgetTester tester, {Locale? locale}) {
    return tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<UsersBloc>.value(value: usersBloc),
          BlocProvider<ConnectivityCubit>.value(value: connectivityCubit),
        ],
        child: MaterialApp(
          locale: locale,
          theme: AppTheme.defaultTheme.themeData,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const UsersScreen(),
        ),
      ),
    );
  }

  testWidgets('shows a loader while the first page loads', (tester) async {
    when(
      () => usersBloc.state,
    ).thenReturn(const UsersState(status: UsersStatus.loading));

    await pumpScreen(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a localized error with retry', (tester) async {
    when(() => usersBloc.state).thenReturn(
      const UsersState(
        status: UsersStatus.failure,
        errorType: AppErrorType.noConnection,
      ),
    );

    await pumpScreen(tester, locale: const Locale('ru'));

    expect(find.text('Повторить'), findsOneWidget);
    expect(find.textContaining('Нет подключения'), findsOneWidget);
  });

  testWidgets('falls back to English for unsupported locales', (tester) async {
    when(() => usersBloc.state).thenReturn(
      const UsersState(
        status: UsersStatus.failure,
        errorType: AppErrorType.noConnection,
      ),
    );

    await pumpScreen(tester, locale: const Locale('fr'));

    expect(find.text('Retry'), findsOneWidget);
  });
}
