import 'package:flutter/material.dart';

import 'app_shell.dart';
import '../screens/auth/landing_screen.dart';
import '../screens/devices/devices_screen.dart';
import '../screens/devices/device_detail_screen.dart';
import '../screens/emergency/active_emergency_screen.dart';
import '../screens/emergency/emergency_choice_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/history/history_detail_screen.dart';
import '../screens/profile/contacts_screen.dart';
import '../screens/profile/edit_contact_screen.dart';
import '../screens/profile/help_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import 'app_state.dart';

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

  static bool isPublic(String? routeName) {
    return routeName == landing || routeName == help;
  }
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    AppStateController appState,
  ) {
    final routeName = settings.name ?? AppRoutes.landing;
    if (!AppRoutes.isPublic(routeName) && !appState.isSignedIn) {
      return _pageRoute(
        settings,
        const LandingScreen(),
      );
    }

    switch (routeName) {
      case AppRoutes.landing:
        return _pageRoute(settings, const LandingScreen());
      case AppRoutes.home:
        return _pageRoute(settings, const AppShell(initialIndex: 0));
      case AppRoutes.history:
        return appState.account.accessibilityMode
            ? _pageRoute(settings, const HistoryPage())
            : _pageRoute(settings, const AppShell(initialIndex: 1));
      case AppRoutes.devices:
        return appState.account.accessibilityMode
            ? _pageRoute(settings, const DevicesPage())
            : _pageRoute(settings, const AppShell(initialIndex: 2));
      case AppRoutes.profile:
        return appState.account.accessibilityMode
            ? _pageRoute(settings, const ProfilePage())
            : _pageRoute(settings, const AppShell(initialIndex: 3));
      case AppRoutes.emergencyChoice:
        return _pageRoute(settings, const EmergencyChoiceScreen());
      case AppRoutes.emergencyActive:
        final incidentId = settings.arguments is String
            ? settings.arguments as String
            : null;
        return _pageRoute(
          settings,
          ActiveEmergencyScreen(incidentId: incidentId),
        );
      case AppRoutes.historyDetail:
        final incidentId = settings.arguments is String
            ? settings.arguments as String
            : null;
        if (appState.incidentByIdOrNull(incidentId) == null) {
          return _pageRoute(
            settings,
            const _UnavailableScreen(
              title: 'History item unavailable',
              message:
                  'This incident record could not be opened. Return to history and choose another item.',
              fallbackRoute: AppRoutes.history,
              fallbackLabel: 'Open history',
            ),
          );
        }
        return _pageRoute(
          settings,
          HistoryDetailScreen(incidentId: incidentId!),
        );
      case AppRoutes.deviceDetail:
        final deviceId = settings.arguments is String
            ? settings.arguments as String
            : null;
        if (appState.deviceByIdOrNull(deviceId) == null) {
          return _pageRoute(
            settings,
            const _UnavailableScreen(
              title: 'Device unavailable',
              message:
                  'This device could not be opened. Return to the devices tab for the latest list.',
              fallbackRoute: AppRoutes.devices,
              fallbackLabel: 'Open devices',
            ),
          );
        }
        return _pageRoute(
          settings,
          DeviceDetailScreen(deviceId: deviceId!),
        );
      case AppRoutes.contacts:
        return _pageRoute(settings, const ContactsScreen());
      case AppRoutes.editContact:
        final requestedId = settings.arguments is String
            ? settings.arguments as String
            : null;
        final resolvedContactId =
            appState.contactById(requestedId) != null ? requestedId : null;
        return _pageRoute(
          settings,
          EditContactScreen(contactId: resolvedContactId),
        );
      case AppRoutes.settings:
        return _pageRoute(settings, const SettingsScreen());
      case AppRoutes.help:
        return _pageRoute(settings, const HelpScreen());
      default:
        return _pageRoute(settings, const LandingScreen());
    }
  }

  static MaterialPageRoute<void> _pageRoute(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute<void>(
      builder: (_) => child,
      settings: settings,
    );
  }
}

class _UnavailableScreen extends StatelessWidget {
  const _UnavailableScreen({
    required this.title,
    required this.message,
    required this.fallbackRoute,
    required this.fallbackLabel,
  });

  final String title;
  final String message;
  final String fallbackRoute;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    fallbackRoute,
                    (route) => false,
                  ),
                  child: Text(fallbackLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
