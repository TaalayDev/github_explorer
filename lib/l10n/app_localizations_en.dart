// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GitHub Explorer';

  @override
  String get usersTitle => 'GitHub Users';

  @override
  String get profileTitle => 'Profile';

  @override
  String get retry => 'Retry';

  @override
  String get offlineBanner => 'No internet connection';

  @override
  String get errorNoConnection =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorRateLimited =>
      'GitHub API rate limit exceeded. Please try again later.';

  @override
  String get errorNotFound => 'User not found.';

  @override
  String get errorServer =>
      'GitHub is unavailable right now. Please try again later.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get emptyUsers => 'No users found';

  @override
  String get noBio => 'No bio';

  @override
  String get company => 'Company';

  @override
  String get location => 'Location';

  @override
  String get website => 'Website';

  @override
  String get joined => 'Joined';

  @override
  String get repositories => 'Repositories';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';
}
