import 'package:chatapp/app.dart';
import 'package:chatapp/screens/screens.dart';
import 'package:chatapp/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final client = StreamChatClient(streamKey);

  runApp(
      MyApp(
          client: client,
          appTheme: AppTheme()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
    required this.appTheme
  }) : super(key: key);

  final StreamChatClient client;
  final AppTheme appTheme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData.dark(),
      theme: appTheme.light,
      darkTheme: appTheme.dark,
      themeMode: ThemeMode.dark,
      title: 'Chat App',
      builder: (context, child) {
        return StreamChatCore(
          client: client,
            child: ChannelsBloc(
                child: UsersBloc(child: child!)
            )
        );
      },
      home: const SplashScreen(),
    );
  }
}


