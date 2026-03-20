import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/pin_screen.dart';
import '../../presentation/screens/chat_screen.dart';
import '../../presentation/screens/voice_interface_screen.dart';
import '../../presentation/screens/files_gallery_screen.dart';
import '../../presentation/screens/settings_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String pin = '/pin';
  static const String chat = '/chat';
  static const String voice = '/voice';
  static const String files = '/files';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: pin,
        name: 'pin',
        builder: (BuildContext context, GoRouterState state) =>
            const PinScreen(),
      ),
      GoRoute(
        path: chat,
        name: 'chat',
        builder: (BuildContext context, GoRouterState state) =>
            const ChatScreen(),
      ),
      GoRoute(
        path: voice,
        name: 'voice',
        builder: (BuildContext context, GoRouterState state) =>
            const VoiceInterfaceScreen(),
      ),
      GoRoute(
        path: files,
        name: 'files',
        builder: (BuildContext context, GoRouterState state) =>
            const FilesGalleryScreen(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
      ),
    ],
  );
}
