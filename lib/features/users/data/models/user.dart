import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.login, required this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }

  final int id;
  final String login;
  final String avatarUrl;

  @override
  List<Object?> get props => [id, login, avatarUrl];
}
