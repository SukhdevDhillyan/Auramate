class UserProfile {
  final String? phoneNumber;
  final String? name;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profilePicturePath;
  final String? city;
  final double? latitude;
  final double? longitude;
  final bool locationPermissionGranted;
  final String? mood;

  UserProfile({
    this.phoneNumber,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.profilePicturePath,
    this.city,
    this.latitude,
    this.longitude,
    this.locationPermissionGranted = false,
    this.mood,
  });

  UserProfile copyWith({
    String? phoneNumber,
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    String? profilePicturePath,
    String? city,
    double? latitude,
    double? longitude,
    bool? locationPermissionGranted,
    String? mood,
  }) {
    return UserProfile(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationPermissionGranted:
          locationPermissionGranted ?? this.locationPermissionGranted,
      mood: mood ?? this.mood,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'profilePicturePath': profilePicturePath,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'locationPermissionGranted': locationPermissionGranted,
      'mood': mood,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      profilePicturePath: json['profilePicturePath'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationPermissionGranted: json['locationPermissionGranted'] ?? false,
      mood: json['mood'],
    );
  }

  bool get isComplete {
    return phoneNumber != null &&
        name != null &&
        dateOfBirth != null &&
        gender != null &&
        city != null;
  }

  @override
  String toString() {
    return 'UserProfile(phoneNumber: $phoneNumber, name: $name, dateOfBirth: $dateOfBirth, gender: $gender, city: $city)';
  }
}
