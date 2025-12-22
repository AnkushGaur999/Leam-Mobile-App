part of 'user_view_model.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();
}

class LoadAllUsersEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserStatusEvent extends UserEvent {
  final bool isOnline;
  const UpdateUserStatusEvent(this.isOnline);

  @override
  List<Object?> get props => [];
}

class UpdateFcmTokenEvent extends UserEvent {
  final String token;
  const UpdateFcmTokenEvent(this.token);

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {
  final String userId;
  const LoadUserEvent(this.userId);

  @override
  List<Object?> get props => [];
}