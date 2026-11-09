// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'GitHub Explorer';

  @override
  String get usersTitle => 'Пользователи GitHub';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get retry => 'Повторить';

  @override
  String get offlineBanner => 'Нет подключения к интернету';

  @override
  String get errorNoConnection =>
      'Нет подключения к интернету. Проверьте сеть и попробуйте снова.';

  @override
  String get errorRateLimited =>
      'Превышен лимит запросов к GitHub API. Попробуйте позже.';

  @override
  String get errorNotFound => 'Пользователь не найден.';

  @override
  String get errorServer => 'GitHub сейчас недоступен. Попробуйте позже.';

  @override
  String get errorUnknown => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get emptyUsers => 'Пользователи не найдены';

  @override
  String get noBio => 'Нет описания';

  @override
  String get company => 'Компания';

  @override
  String get location => 'Местоположение';

  @override
  String get website => 'Сайт';

  @override
  String get joined => 'Регистрация';

  @override
  String get repositories => 'Репозитории';

  @override
  String get followers => 'Подписчики';

  @override
  String get following => 'Подписки';

  @override
  String get searchHint => 'Поиск пользователей';

  @override
  String get filtersTitle => 'Фильтры';

  @override
  String get resetFilters => 'Сбросить';

  @override
  String get accountTypeTitle => 'Тип аккаунта';

  @override
  String get accountTypeAll => 'Все';

  @override
  String get accountTypeUser => 'Пользователи';

  @override
  String get accountTypeOrg => 'Организации';

  @override
  String get sortByTitle => 'Сортировка';

  @override
  String get sortBestMatch => 'Лучшее совпадение';

  @override
  String get sortFollowers => 'По подписчикам';

  @override
  String get sortRepositories => 'По репозиториям';

  @override
  String get sortJoined => 'По дате регистрации';

  @override
  String get orderTitle => 'Порядок';

  @override
  String get orderDescending => 'По убыванию';

  @override
  String get orderAscending => 'По возрастанию';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageSystem => 'Как в системе';
}
