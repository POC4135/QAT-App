import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchResult {
  const LaunchResult._({
    required this.didLaunch,
    this.failureMessage,
  });

  const LaunchResult.success() : this._(didLaunch: true);

  const LaunchResult.failure(String message)
      : this._(
          didLaunch: false,
          failureMessage: message,
        );

  final bool didLaunch;
  final String? failureMessage;
}

abstract class LaunchService {
  Future<LaunchResult> launch(
    Uri uri, {
    required String failureMessage,
  });
}

class UrlLauncherService implements LaunchService {
  const UrlLauncherService();

  @override
  Future<LaunchResult> launch(
    Uri uri, {
    required String failureMessage,
  }) async {
    try {
      final supported = await canLaunchUrl(uri);
      if (!supported) {
        return LaunchResult.failure(failureMessage);
      }

      final launched = await launchUrl(uri);
      if (!launched) {
        return LaunchResult.failure(failureMessage);
      }

      return const LaunchResult.success();
    } catch (_) {
      return LaunchResult.failure(failureMessage);
    }
  }
}

class LaunchServiceScope extends InheritedWidget {
  const LaunchServiceScope({
    super.key,
    required this.service,
    required super.child,
  });

  final LaunchService service;

  static LaunchService of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<LaunchServiceScope>();
    assert(scope != null, 'LaunchServiceScope not found in context');
    return scope!.service;
  }

  @override
  bool updateShouldNotify(LaunchServiceScope oldWidget) {
    return oldWidget.service != service;
  }
}

Future<bool> launchPhoneCall(
  BuildContext context,
  String phone, {
  String? failureMessage,
}) {
  return _launchWithFallback(
    context,
    Uri(scheme: 'tel', path: phone),
    failureMessage:
        failureMessage ??
        'We could not place that call from this device. Please call $phone manually.',
  );
}

Future<bool> launchSmsMessage(
  BuildContext context,
  String phone, {
  String? failureMessage,
}) {
  return _launchWithFallback(
    context,
    Uri(scheme: 'sms', path: phone),
    failureMessage:
        failureMessage ??
        'We could not open messaging on this device. Please text $phone manually.',
  );
}

Future<bool> launchEmailMessage(
  BuildContext context,
  String email, {
  String? subject,
  String? failureMessage,
}) {
  return _launchWithFallback(
    context,
    Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: subject == null ? null : {'subject': subject},
    ),
    failureMessage:
        failureMessage ??
        'We could not open your email app. Please email $email manually.',
  );
}

Future<bool> launchWebsiteLink(
  BuildContext context,
  String url, {
  String? failureMessage,
}) {
  return _launchWithFallback(
    context,
    Uri.parse(url),
    failureMessage:
        failureMessage ??
        'We could not open that website from this device. Please try again later.',
  );
}

Future<bool> _launchWithFallback(
  BuildContext context,
  Uri uri, {
  required String failureMessage,
}) async {
  final result = await LaunchServiceScope.of(context).launch(
    uri,
    failureMessage: failureMessage,
  );
  if (!context.mounted) {
    return result.didLaunch;
  }
  if (!result.didLaunch) {
    await _showLaunchFailureDialog(
      context,
      result.failureMessage ?? failureMessage,
    );
  }
  return result.didLaunch;
}

Future<void> _showLaunchFailureDialog(
  BuildContext context,
  String message,
) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Action unavailable'),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
