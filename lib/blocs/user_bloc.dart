import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/models/user.dart';
import '../data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserLoad) {
      yield* _mapUserLoadToState();
    } else if (event is UserCreate) {
      yield* _mapUserCreateToState(event);
    } else if (event is UserUpdate) {
      yield* _mapUserUpdateToState(event);
    } else if (event is UserDelete) {
      yield* _mapUserDeleteToState(event);
    }
  }

  Stream<UserState> _mapUserLoadToState() async* {
    yield UserLoading();
    try {
      final users = await userRepository.getUsers();
      yield UserLoadSuccess(users: users);
    } catch (e) {
      yield UserOperationFailure(error: '$e');
    }
  }

  Stream<UserState> _mapUserCreateToState(UserCreate event) async* {
    yield UserLoading();
    try {
      final newUser = await userRepository.createUser(event.user);
      final List<User> updatedUsers =
          List.from((state as UserLoadSuccess).users)..add(newUser);
      yield UserLoadSuccess(users: updatedUsers);
    } catch (e) {
      yield UserOperationFailure(error: '$e');
    }
  }

  Stream<UserState> _mapUserUpdateToState(UserUpdate event) async* {
    yield UserLoading();
    try {
      final User updatedUser = await userRepository.updateUser(event.user);
      final List<User> updatedUsers = [
        ...((state as UserLoadSuccess).users).take(updatedUser.id - 1),
        updatedUser,
        ...((state as UserLoadSuccess).users).skip(updatedUser.id),
      ];
      yield UserLoadSuccess(users: updatedUsers); // Add this line
    } catch (e) {
      yield UserOperationFailure(error: '$e');
    }
  }

  Stream<UserState> _mapUserDeleteToState(UserDelete event) async* {
    yield UserLoading();
    try {
      await userRepository.deleteUser(event.id);
      final List<User> updatedUsers =
          List.from((state as UserLoadSuccess).users)
            ..removeWhere((user) => user.id == event.id);
      yield UserLoadSuccess(users: updatedUsers);
    } catch (e) {
      yield UserOperationFailure(error: '$e');
    }
  }
}
