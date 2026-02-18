import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, isEmailVerified];
}
