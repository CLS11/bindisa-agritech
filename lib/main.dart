import 'package:agritech/bloc/approval_bloc.dart';
import 'package:agritech/bloc/bug_report_bloc.dart';
import 'package:agritech/bloc/chat_message_bloc.dart';
import 'package:agritech/bloc/notification_bloc.dart';
import 'package:agritech/bloc/profile_bloc.dart';
import 'package:agritech/bloc/profile_event.dart';
import 'package:agritech/bloc/video_bloc.dart';
import 'package:agritech/screens/approval_flags_screen.dart';
import 'package:agritech/screens/bug_report_main_screen.dart';
import 'package:agritech/screens/help_support_screen.dart';
import 'package:agritech/screens/notifications_screen.dart';
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProfileBloc()..add(LoadProfile()),
          ),
          BlocProvider(
            create: (context) => BugReportBloc(), // Provide BugReportBloc
          ),
          BlocProvider(
            create: (context) => NotificationBloc(), // Provide NotificationBloc
          ),
          BlocProvider(
            create: (context) => ChatBloc(), // Provide ChatBloc
          ),
          BlocProvider(
            create: (context) => VideoBloc(), // Provide VideoBloc
          ),
          BlocProvider(
            create: (context) => ApprovalBloc(), // Provide ApprovalBloc
          ),
        ], 
        child: const ApprovalFlagsScreen(),
      ),
    );
  }
}
