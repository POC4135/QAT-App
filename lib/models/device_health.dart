enum DeviceStatus { online, needsAttention, offline }

class DeviceHealth {
  const DeviceHealth({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.summary,
    required this.detailHint,
    required this.lastCheckIn,
    required this.batteryLabel,
  });

  final String id;
  final String name;
  final String location;
  final DeviceStatus status;
  final String summary;
  final String detailHint;
  final String lastCheckIn;
  final String batteryLabel;

  DeviceHealth copyWith({
    String? id,
    String? name,
    String? location,
    DeviceStatus? status,
    String? summary,
    String? detailHint,
    String? lastCheckIn,
    String? batteryLabel,
  }) {
    return DeviceHealth(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      detailHint: detailHint ?? this.detailHint,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      batteryLabel: batteryLabel ?? this.batteryLabel,
    );
  }
}
