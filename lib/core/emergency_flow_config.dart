import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'app_preferences.dart';

class EmergencyFlowConfig {
  const EmergencyFlowConfig({
    required this.emergencyAutoTriggerSeconds,
  });

  static const int defaultSeconds = 10;
  static const int minimumSeconds = 3;
  static const int maximumSeconds = 30;

  final int emergencyAutoTriggerSeconds;

  factory EmergencyFlowConfig.defaults() {
    return const EmergencyFlowConfig(
      emergencyAutoTriggerSeconds: defaultSeconds,
    );
  }

  factory EmergencyFlowConfig.fromJson(Map<String, dynamic> json) {
    final rawValue = json['emergencyAutoTriggerSeconds'];
    final parsedSeconds = _parseSeconds(rawValue);
    if (parsedSeconds == null) {
      throw const FormatException(
        'emergencyAutoTriggerSeconds must be a number between 3 and 30.',
      );
    }

    return EmergencyFlowConfig(
      emergencyAutoTriggerSeconds: sanitizeSeconds(parsedSeconds),
    );
  }

  static int sanitizeSeconds(int value) {
    return value.clamp(minimumSeconds, maximumSeconds);
  }

  static int? _parseSeconds(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  Map<String, Object> toJson() {
    return {
      'emergencyAutoTriggerSeconds': emergencyAutoTriggerSeconds,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is EmergencyFlowConfig &&
        other.emergencyAutoTriggerSeconds == emergencyAutoTriggerSeconds;
  }

  @override
  int get hashCode => emergencyAutoTriggerSeconds.hashCode;
}

enum EmergencyFlowConfigLoadStatus { idle, refreshing, ready, fallback }

abstract interface class EmergencyFlowConfigRepository {
  Future<EmergencyFlowConfig> fetch();
}

class HttpEmergencyFlowConfigRepository
    implements EmergencyFlowConfigRepository {
  HttpEmergencyFlowConfigRepository({
    required this.uri,
    http.Client? client,
    this.timeout = const Duration(seconds: 2),
  }) : _client = client ?? http.Client();

  final Uri uri;
  final http.Client _client;
  final Duration timeout;

  @override
  Future<EmergencyFlowConfig> fetch() async {
    final requestUri = uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        '_qatConfigTs': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
    final response = await _client
        .get(
          requestUri,
          headers: const {
            'accept': 'application/json',
          },
        )
        .timeout(timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Remote config fetch failed with status ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Remote config must be a JSON object.');
    }

    return EmergencyFlowConfig.fromJson(decoded);
  }
}

EmergencyFlowConfigRepository? buildEmergencyFlowConfigRepository({
  required String rawUrl,
  Uri? webBaseUri,
  http.Client? client,
}) {
  final trimmedUrl = rawUrl.trim();
  if (trimmedUrl.isNotEmpty) {
    final uri = Uri.tryParse(trimmedUrl);
    if (uri != null && uri.scheme == 'https') {
      return HttpEmergencyFlowConfigRepository(
        uri: uri,
        client: client,
      );
    }
  }

  if (webBaseUri != null) {
    return HttpEmergencyFlowConfigRepository(
      uri: webBaseUri.resolve('config/emergency_flow.json'),
      client: client,
    );
  }

  return null;
}

EmergencyFlowConfigRepository? buildEmergencyFlowConfigRepositoryFromEnvironment({
  http.Client? client,
}) {
  return buildEmergencyFlowConfigRepository(
    rawUrl: const String.fromEnvironment('QAT_REMOTE_CONFIG_URL'),
    webBaseUri: kIsWeb ? Uri.base : null,
    client: client,
  );
}

class EmergencyFlowConfigController extends ChangeNotifier {
  EmergencyFlowConfigController({
    this.preferences,
    this.repository,
    EmergencyFlowConfig? initialConfig,
  }) : _config = initialConfig ??
            EmergencyFlowConfig(
              emergencyAutoTriggerSeconds: EmergencyFlowConfig.sanitizeSeconds(
                preferences?.cachedEmergencyAutoTriggerSeconds ??
                    EmergencyFlowConfig.defaultSeconds,
              ),
            );

  final AppPreferencesStore? preferences;
  final EmergencyFlowConfigRepository? repository;

  EmergencyFlowConfig _config;
  EmergencyFlowConfigLoadStatus _status = EmergencyFlowConfigLoadStatus.idle;
  Object? _lastError;
  Future<void>? _inFlightRefresh;

  EmergencyFlowConfig get currentConfig => _config;
  int get countdownSeconds => _config.emergencyAutoTriggerSeconds;
  EmergencyFlowConfigLoadStatus get status => _status;
  Object? get lastError => _lastError;

  Future<void> refresh() {
    if (_inFlightRefresh != null) {
      return _inFlightRefresh!;
    }

    final activeRepository = repository;
    if (activeRepository == null) {
      _status = EmergencyFlowConfigLoadStatus.fallback;
      _lastError = StateError('Remote config URL is not configured.');
      notifyListeners();
      return Future<void>.value();
    }

    _status = EmergencyFlowConfigLoadStatus.refreshing;
    _lastError = null;
    notifyListeners();

    final refreshFuture = _refresh(activeRepository);
    _inFlightRefresh = refreshFuture.whenComplete(() {
      _inFlightRefresh = null;
    });
    return _inFlightRefresh!;
  }

  Future<void> _refresh(EmergencyFlowConfigRepository activeRepository) async {
    try {
      final fetchedConfig = await activeRepository.fetch();
      _config = fetchedConfig;
      _status = EmergencyFlowConfigLoadStatus.ready;
      _lastError = null;
      notifyListeners();

      await preferences?.setCachedEmergencyAutoTriggerSeconds(
        fetchedConfig.emergencyAutoTriggerSeconds,
      );
      await preferences?.setCachedEmergencyConfigFetchedAtMs(
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (error) {
      _status = EmergencyFlowConfigLoadStatus.fallback;
      _lastError = error;
      notifyListeners();
    }
  }
}

class EmergencyFlowConfigScope
    extends InheritedNotifier<EmergencyFlowConfigController> {
  const EmergencyFlowConfigScope({
    super.key,
    required EmergencyFlowConfigController notifier,
    required super.child,
  }) : super(notifier: notifier);

  static EmergencyFlowConfigController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<EmergencyFlowConfigScope>();
    assert(scope != null, 'EmergencyFlowConfigScope not found in context');
    return scope!.notifier!;
  }

  static EmergencyFlowConfigController read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<
        EmergencyFlowConfigScope>();
    final widget = element?.widget;
    assert(widget != null, 'EmergencyFlowConfigScope not found in context');
    return (widget as EmergencyFlowConfigScope).notifier!;
  }
}
