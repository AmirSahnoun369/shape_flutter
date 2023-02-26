part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoadSuccess extends UserState {
  final List<User> users;

  UserLoadSuccess({required this.users});
}

class UserOperationSuccess extends UserState {}

class UserOperationFailure extends UserState {
  final String error;

  UserOperationFailure({required this.error});
}

class UserLoadFailure extends UserState {
  final String error;

  UserLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
