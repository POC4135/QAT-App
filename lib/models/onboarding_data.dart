/// Data models collected during the onboarding flow.
/// These are held in memory and persisted to the backend once onboarding
/// completes. They are intentionally separate from [EmergencyContact] so
/// that the onboarding flow can stand alone before backend calls are wired.

class OnboardingProfile {
  const OnboardingProfile({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.profilePhotoPath,
  });

  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String phoneNumber;
  final String email;
  final String? profilePhotoPath;

  String get fullName => '$firstName $lastName'.trim();

  OnboardingProfile copyWith({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? phoneNumber,
    String? email,
    String? profilePhotoPath,
  }) {
    return OnboardingProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }
}

class OnboardingLocation {
  const OnboardingLocation({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.houseIdentifier,
  });

  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String houseIdentifier; // e.g. "Unit 12", "Block B"

  String get singleLine =>
      [addressLine1, addressLine2, city, state, postalCode]
          .where((s) => s.trim().isNotEmpty)
          .join(', ');

  OnboardingLocation copyWith({
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? houseIdentifier,
  }) {
    return OnboardingLocation(
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      houseIdentifier: houseIdentifier ?? this.houseIdentifier,
    );
  }
}

class OnboardingAllergy {
  const OnboardingAllergy({required this.id, required this.name});
  final String id;
  final String name;
}

class OnboardingMedication {
  const OnboardingMedication({
    required this.id,
    required this.name,
    required this.dose,
    required this.frequency,
  });
  final String id;
  final String name;
  final String dose;
  final String frequency;
}

class OnboardingDoctor {
  const OnboardingDoctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.phone,
  });
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String phone;
}

class OnboardingMedical {
  const OnboardingMedical({
    required this.bloodType,
    required this.allergies,
    required this.medications,
    required this.doctors,
    required this.medicalNotes,
  });

  final String bloodType; // e.g. "A+", "Unknown"
  final List<OnboardingAllergy> allergies;
  final List<OnboardingMedication> medications;
  final List<OnboardingDoctor> doctors;
  final String medicalNotes;

  OnboardingMedical copyWith({
    String? bloodType,
    List<OnboardingAllergy>? allergies,
    List<OnboardingMedication>? medications,
    List<OnboardingDoctor>? doctors,
    String? medicalNotes,
  }) {
    return OnboardingMedical(
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      doctors: doctors ?? this.doctors,
      medicalNotes: medicalNotes ?? this.medicalNotes,
    );
  }
}

class OnboardingHospital {
  const OnboardingHospital({
    required this.id,
    required this.name,
    required this.address,
  });
  final String id;
  final String name;
  final String address;
}

class OnboardingHealth {
  const OnboardingHealth({
    required this.preferredHospitals,
    required this.preferredDoctors,
  });

  final List<OnboardingHospital> preferredHospitals;
  final List<OnboardingDoctor> preferredDoctors;

  OnboardingHealth copyWith({
    List<OnboardingHospital>? preferredHospitals,
    List<OnboardingDoctor>? preferredDoctors,
  }) {
    return OnboardingHealth(
      preferredHospitals: preferredHospitals ?? this.preferredHospitals,
      preferredDoctors: preferredDoctors ?? this.preferredDoctors,
    );
  }
}

class OnboardingHouseholdMember {
  const OnboardingHouseholdMember({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
  });
  final String id;
  final String fullName;
  final String phone;
  final String email;
}

class OnboardingEmergencyContact {
  const OnboardingEmergencyContact({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.relation,
    required this.isPrimary,
  });

  final String id;
  final String fullName;
  final String phone;
  final String relation;
  final bool isPrimary;

  String get avatarInitials {
    final parts = fullName.trim().split(' ');
    return parts.map((w) => w.isEmpty ? '' : w[0]).join().toUpperCase().substring(
          0,
          parts.length >= 2 ? 2 : 1,
        );
  }
}

/// Aggregates all data collected across the 6 onboarding steps.
class OnboardingData {
  const OnboardingData({
    this.profile,
    this.location,
    this.medical,
    this.health,
    this.householdMembers = const [],
    this.emergencyContacts = const [],
  });

  final OnboardingProfile? profile;
  final OnboardingLocation? location;
  final OnboardingMedical? medical;
  final OnboardingHealth? health;
  final List<OnboardingHouseholdMember> householdMembers;
  final List<OnboardingEmergencyContact> emergencyContacts;

  static const empty = OnboardingData();

  OnboardingData copyWith({
    OnboardingProfile? profile,
    OnboardingLocation? location,
    OnboardingMedical? medical,
    OnboardingHealth? health,
    List<OnboardingHouseholdMember>? householdMembers,
    List<OnboardingEmergencyContact>? emergencyContacts,
  }) {
    return OnboardingData(
      profile: profile ?? this.profile,
      location: location ?? this.location,
      medical: medical ?? this.medical,
      health: health ?? this.health,
      householdMembers: householdMembers ?? this.householdMembers,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
    );
  }
}
