
part of 'chat_view_model.dart';

sealed class ChatState extends Equatable{}

final class ChatInitial extends ChatState{
  @override
  List<Object> get props => [];
}
