import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/profile_data.dart';
import 'package:leam/src/repositories/chat_repository.dart';

part 'user_events.dart';

part 'user_states.dart';

class UserViewModel extends Bloc<UserEvents, UserStates> {
  final ChatRepository repository;

  List<ProfileData> _users = [];

  UserViewModel({required this.repository}) : super(UserInitial()) {
    on<GetAllUsersEvent>(_getAllUsers);
    on<SearchUserEvent>(_searchUsers);

    add(GetAllUsersEvent());
  }

  Future<void> _getAllUsers(
    GetAllUsersEvent event,
    Emitter<UserStates> emit,
  ) async {
    emit(AllUserLoading());

    final response = await repository.getAllUserInfo();

    if (response is DataSuccess) {
      _users = response.data ?? [];

      emit(AllUserLoaded(users: _users));
    } else {
      emit(AllUserError(message: response.message!));
    }
  }

  void _searchUsers(SearchUserEvent event, Emitter<UserStates> emit) {
    final query = event.query.toLowerCase();
    final filtered = _users.where((user) {
      final name = user.name?.toLowerCase() ?? '';
    //  final email = user.email?.toLowerCase() ?? '';
      return name.contains(query); // || email.contains(query);
    }).toList();

    emit(AllUserLoaded(users: filtered));
  }
}
