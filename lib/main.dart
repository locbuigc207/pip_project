import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pippips/models/hive_models/chat_message.dart';
import 'package:pippips/models/hive_models/conversation.dart';
import 'package:pippips/routes/app_router.dart';
import 'package:pippips/utils/auth_manager.dart';
import 'package:pippips/utils/session_validator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ConversationAdapter());
  await Hive.openBox<Conversation>('conversationBox');

  final isLoggedIn = await AuthManager.isLoggedIn();
  final isGuest = await AuthManager.isGuestMode();

  if (isLoggedIn && !isGuest) {
    print(' User is logged in, starting session validator...');
    SessionValidator().start();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SessionValidator().stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print(' App resumed');
        _checkAndStartValidator();
        break;
      case AppLifecycleState.paused:
        print(' App paused');
        break;
      case AppLifecycleState.inactive:
        print(' App inactive');
        break;
      case AppLifecycleState.detached:
        print(' App detached');
        SessionValidator().stop();
        break;
      default:
        break;
    }
  }

  Future<void> _checkAndStartValidator() async {
    final isLoggedIn = await AuthManager.isLoggedIn();
    final isGuest = await AuthManager.isGuestMode();

    if (isLoggedIn && !isGuest && !SessionValidator().isRunning) {
      print(' Starting session validator on app resume...');
      SessionValidator().start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Pippip Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}