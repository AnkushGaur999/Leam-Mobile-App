import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/user/user_data_model.dart';
import 'package:leam/src/repositories/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserViewModel extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserViewModel({required this.repository}) : super(UserInitial()) {
    on<LoadAllUsersEvent>(_onLoadAllUsers);
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserStatusEvent>(_onUpdateUserStatus);
    on<UpdateFcmTokenEvent>(_onUpdateFcmToken);
  }

  Future<void> _onLoadAllUsers(
    LoadAllUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    final result = await repository.getAllUsers();

    if (result is DataSuccess<List<UserDataModel>>) {
      emit(UsersLoaded(result.data!));
    } else if (result is DataError) {
      emit(UserError(result.message ?? 'Failed to load users'));
    }
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await repository.getUser(event.userId);

    if (result is DataSuccess<UserDataModel>) {
      emit(UserLoaded(result.data!));
    } else if (result is DataError) {
      emit(UserError(result.message ?? 'Failed to load user'));
    }
  }

  Future<void> _onUpdateUserStatus(
    UpdateUserStatusEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await repository.updateUserStatus(event.isOnline);

    if (result is DataSuccess) {
      emit(UserStatusUpdated());
    } else if (result is DataError) {
      emit(UserStatusUpdateError(result.message ?? 'Failed to update status'));
    }
  }

  Future<void> _onUpdateFcmToken(
    UpdateFcmTokenEvent event,
    Emitter<UserState> emit,
  ) async {
    await repository.updateFcmToken(event.token);
  }
}
