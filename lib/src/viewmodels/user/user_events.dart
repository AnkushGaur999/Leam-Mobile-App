part of 'user_view_model.dart';

sealed class UserEvents extends Equatable {}

final class GetAllUsersEvent extends UserEvents {
  @override
  List<Object?> get props => [];
}

final class SearchUserEvent extends UserEvents {
  final String query;

  SearchUserEvent(this.query);

  @override
  List<Object?> get props => [query];
}
