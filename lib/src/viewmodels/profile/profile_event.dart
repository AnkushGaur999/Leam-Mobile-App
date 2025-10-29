
part of "profile_view_model.dart";


sealed class ProfileEvent extends Equatable{}

final class GetProfileDetailsEvent extends ProfileEvent{
  @override
  List<Object?> get props => [];
}