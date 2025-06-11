import 'package:agritech/bloc/profile_bloc.dart';
import 'package:agritech/bloc/profile_event.dart';
import 'package:agritech/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const AgriTech());
}

class AgriTech extends StatelessWidget {
  const AgriTech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Inter',
      ),
      home: BlocProvider(
        create: (context) => ProfileBloc()..add(
          LoadProfile(),
        ),
        child: const ProfileScreen(),
      ),
    );
  }
}
