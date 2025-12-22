part of 'user_view_model.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

final class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

final class UsersLoaded extends UserState {
  final List<UserDataModel> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

final class UserLoaded extends UserState {
  final UserDataModel user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

final class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

final class UserStatusUpdated extends UserState {
  @override
  List<Object?> get props => [];
}

final class UserStatusUpdateError extends UserState {
  final String message;

  const UserStatusUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
