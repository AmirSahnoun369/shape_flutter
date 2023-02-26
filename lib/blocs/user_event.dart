part of 'user_bloc.dart';

abstract class UserEvent {}

class UserLoad extends UserEvent {}

class UserCreate extends UserEvent {
  final User user;

  UserCreate({required this.user});
}

class UserUpdate extends UserEvent {
  final User user;

  UserUpdate({required this.user});
}

class UserDelete extends UserEvent {
  final int id;

  UserDelete({required this.id});
}
