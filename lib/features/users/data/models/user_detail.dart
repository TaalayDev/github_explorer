import 'package:equatable/equatable.dart';

class UserDetail extends Equatable {
  const UserDetail({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.followers,
    required this.following,
    required this.publicRepos,
    required this.createdAt,
    this.name,
    this.bio,
    this.company,
    this.location,
    this.blog,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      publicRepos: json['public_repos'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      name: _nonEmpty(json['name']),
      bio: _nonEmpty(json['bio']),
      company: _nonEmpty(json['company']),
      location: _nonEmpty(json['location']),
      blog: _nonEmpty(json['blog']),
    );
  }

  final int id;
  final String login;
  final String avatarUrl;
  final int followers;
  final int following;
  final int publicRepos;
  final DateTime createdAt;
  final String? name;
  final String? bio;
  final String? company;
  final String? location;
  final String? blog;

  String get displayName => name ?? login;

  @override
  List<Object?> get props => [
    id,
    login,
    avatarUrl,
    followers,
    following,
    publicRepos,
    createdAt,
    name,
    bio,
    company,
    location,
    blog,
  ];
}

String? _nonEmpty(Object? value) {
  final text = (value as String?)?.trim();
  return text == null || text.isEmpty ? null : text;
}
