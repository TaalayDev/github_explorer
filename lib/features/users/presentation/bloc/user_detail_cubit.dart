import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/state/loadable.dart';
import '../../data/models/user_detail.dart';
import '../../data/repositories/users_repository.dart';

class UserDetailCubit extends Cubit<Loadable<UserDetail>> {
  UserDetailCubit(this._repository, this._login) : super(const Loadable.loading());

  final UsersRepository _repository;
  final String _login;

  Future<void> load() async {
    emit(const Loadable.loading());
    try {
      emit(Loadable.success(await _repository.getUser(_login)));
    } on AppException catch (exception) {
      emit(Loadable.error(exception.type.name));
    }
  }
}
