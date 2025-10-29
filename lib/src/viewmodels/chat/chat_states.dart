
part of 'chat_view_model.dart';

sealed class ChatStates extends Equatable{}

final class ChatInitial extends ChatStates{
  @override
  List<Object> get props => [];
}
