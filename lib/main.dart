import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_crud_app/blocs/user_bloc.dart';
import 'package:user_crud_app/data/providers/user_provider.dart';
import 'package:user_crud_app/data/repositories/user_repository.dart';
import 'package:user_crud_app/screens/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository(UserProvider);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) =>
            UserBloc(userRepository: userRepository)..add(UserLoad()),
        child: UserListScreen(),
      ),
    );
  }
}
