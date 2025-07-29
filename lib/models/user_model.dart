class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String passwordHash;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? securityQuestion;
  final String? securityAnswer;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passwordHash,
    this.phoneNumber,
    this.dateOfBirth,
    this.profileImage,
    required this.createdAt,
    this.lastLoginAt,
    this.securityQuestion,
    this.securityAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'passwordHash': passwordHash,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'securityQuestion': securityQuestion,
      'securityAnswer': securityAnswer,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'])
          : null,
      securityQuestion: json['securityQuestion'],
      securityAnswer: json['securityAnswer'],
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      passwordHash: '',
      phoneNumber: '',
      dateOfBirth: null,
      profileImage: '',
      createdAt: DateTime.now(),
      lastLoginAt: null,
      securityQuestion: '',
      securityAnswer: '',
    );
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? passwordHash,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? profileImage,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? securityQuestion,
    String? securityAnswer,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      securityQuestion: securityQuestion ?? this.securityQuestion,
      securityAnswer: securityAnswer ?? this.securityAnswer,
    );
  }
}
