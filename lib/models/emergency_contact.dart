class EmergencyContact {
  const EmergencyContact({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.relationship,
    required this.priority,
    required this.isPrimary,
    required this.supportsMessaging,
  });

  final String id;
  final String name;
  final String role;
  final String phone;
  final String relationship;
  final int priority;
  final bool isPrimary;
  final bool supportsMessaging;

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    String? relationship,
    int? priority,
    bool? isPrimary,
    bool? supportsMessaging,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      priority: priority ?? this.priority,
      isPrimary: isPrimary ?? this.isPrimary,
      supportsMessaging: supportsMessaging ?? this.supportsMessaging,
    );
  }
}
