
part of 'user_view_model.dart';

sealed class UserStates extends Equatable {
  const UserStates();
}

final class UserInitial extends UserStates {
  @override
  List<Object?> get props => [];
}

final class AllUserLoading extends UserStates {
  @override
  List<Object?> get props => [];
}

final class AllUserLoaded extends UserStates {
  final List<ProfileData> users;

  const AllUserLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

final class AllUserError extends UserStates {
  final String message;

  const AllUserError({required this.message});

  @override
  List<Object?> get props => [message];
}
