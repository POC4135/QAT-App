import 'package:flutter/material.dart';

import 'app_shell.dart';
import '../screens/auth/landing_screen.dart';
import '../screens/devices/device_detail_screen.dart';
import '../screens/emergency/active_emergency_screen.dart';
import '../screens/emergency/emergency_choice_screen.dart';
import '../screens/history/history_detail_screen.dart';
import '../screens/profile/contacts_screen.dart';
import '../screens/profile/edit_contact_screen.dart';
import '../screens/profile/help_screen.dart';
import '../screens/profile/settings_screen.dart';

class AppRoutes {
  static const landing = '/';
  static const home = '/home';
  static const emergencyChoice = '/emergency/choose';
  static const emergencyActive = '/emergency/active';
  static const history = '/history';
  static const historyDetail = '/history/detail';
  static const devices = '/devices';
  static const deviceDetail = '/devices/detail';
  static const profile = '/profile';
  static const contacts = '/profile/contacts';
  static const editContact = '/profile/contacts/edit';
  static const settings = '/profile/settings';
  static const help = '/profile/help';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.landing:
        return MaterialPageRoute<void>(
          builder: (_) => const LandingScreen(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(initialIndex: 0),
          settings: settings,
        );
      case AppRoutes.history:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(initialIndex: 1),
          settings: settings,
        );
      case AppRoutes.devices:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(initialIndex: 2),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(initialIndex: 3),
          settings: settings,
        );
      case AppRoutes.emergencyChoice:
        return MaterialPageRoute<void>(
          builder: (_) => const EmergencyChoiceScreen(),
          settings: settings,
        );
      case AppRoutes.emergencyActive:
        return MaterialPageRoute<void>(
          builder: (_) =>
              ActiveEmergencyScreen(incidentId: settings.arguments as String?),
          settings: settings,
        );
      case AppRoutes.historyDetail:
        return MaterialPageRoute<void>(
          builder: (_) =>
              HistoryDetailScreen(incidentId: settings.arguments as String),
          settings: settings,
        );
      case AppRoutes.deviceDetail:
        return MaterialPageRoute<void>(
          builder: (_) =>
              DeviceDetailScreen(deviceId: settings.arguments as String),
          settings: settings,
        );
      case AppRoutes.contacts:
        return MaterialPageRoute<void>(
          builder: (_) => const ContactsScreen(),
          settings: settings,
        );
      case AppRoutes.editContact:
        return MaterialPageRoute<void>(
          builder: (_) =>
              EditContactScreen(contactId: settings.arguments as String?),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute<void>(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      case AppRoutes.help:
        return MaterialPageRoute<void>(
          builder: (_) => const HelpScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LandingScreen(),
          settings: settings,
        );
    }
  }
}
