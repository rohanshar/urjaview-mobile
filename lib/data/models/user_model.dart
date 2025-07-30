class UserModel {
  final String id;
  final String email;
  final String role;
  final String clientId;
  final String? name;
  final String? companyId;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.clientId,
    this.name,
    this.companyId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['sub'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['custom:role'] ?? json['role'] ?? 'user',
      clientId: json['custom:clientId'] ?? json['clientId'] ?? '',
      name: json['name'],
      companyId: json['custom:companyId'] ?? json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'clientId': clientId,
      'name': name,
      'companyId': companyId,
    };
  }
}
