class MeterAuthenticationModel {
  final AuthLevelConfig? none;
  final AuthLevelConfig? low;
  final AuthLevelConfig? high;

  MeterAuthenticationModel({
    this.none,
    this.low,
    this.high,
  });

  factory MeterAuthenticationModel.fromJson(Map<String, dynamic> json) {
    return MeterAuthenticationModel(
      none: json['none'] != null 
          ? AuthLevelConfig.fromJson(json['none']) 
          : null,
      low: json['low'] != null 
          ? AuthLevelConfig.fromJson(json['low']) 
          : null,
      high: json['high'] != null 
          ? AuthLevelConfig.fromJson(json['high']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (none != null) 'none': none!.toJson(),
      if (low != null) 'low': low!.toJson(),
      if (high != null) 'high': high!.toJson(),
    };
  }

  bool get hasAnyEnabled => 
      (none?.enabled ?? false) || 
      (low?.enabled ?? false) || 
      (high?.enabled ?? false);

  bool get hasHighAuth => high?.enabled ?? false;
  bool get hasLowAuth => low?.enabled ?? false;
  bool get hasNoneAuth => none?.enabled ?? false;

  // Check if meter has write capabilities (requires high auth)
  bool get canWrite => hasHighAuth && high!.password != null;

  // Get the best available auth level
  String get bestAvailableLevel {
    if (hasHighAuth) return 'High';
    if (hasLowAuth) return 'Low';
    if (hasNoneAuth) return 'None';
    return 'None';
  }
}

class AuthLevelConfig {
  final bool enabled;
  final String? password;
  final String? systemTitle;
  final String? authKey;
  final String? blockCipherKey;

  AuthLevelConfig({
    required this.enabled,
    this.password,
    this.systemTitle,
    this.authKey,
    this.blockCipherKey,
  });

  factory AuthLevelConfig.fromJson(Map<String, dynamic> json) {
    return AuthLevelConfig(
      enabled: json['enabled'] ?? false,
      password: json['password'],
      systemTitle: json['systemTitle'],
      authKey: json['authKey'],
      blockCipherKey: json['blockCipherKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      if (password != null) 'password': password,
      if (systemTitle != null) 'systemTitle': systemTitle,
      if (authKey != null) 'authKey': authKey,
      if (blockCipherKey != null) 'blockCipherKey': blockCipherKey,
    };
  }
}