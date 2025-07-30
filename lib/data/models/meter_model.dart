import 'meter_authentication_model.dart';

class MeterModel {
  final String id;
  final String name;
  final String serialNumber;
  final String meterIp;
  final int port;
  final String status;
  final String? manufacturer;
  final String? model;
  final String? location;
  final String? notes;
  final MeterAuthenticationModel? authentication;
  final String? lastSyncTime;
  final Map<String, dynamic>? lastSyncData;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? connectionStatus;
  final DateTime? lastReadTime;

  MeterModel({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.meterIp,
    required this.port,
    required this.status,
    this.manufacturer,
    this.model,
    this.location,
    this.notes,
    this.authentication,
    this.lastSyncTime,
    this.lastSyncData,
    required this.createdAt,
    required this.updatedAt,
    this.connectionStatus,
    this.lastReadTime,
  });

  factory MeterModel.fromJson(Map<String, dynamic> json) {
    // Handle nested network object
    final network = json['network'] as Map<String, dynamic>?;

    // Extract metadata
    final metadata = json['metadata'] as Map<String, dynamic>?;

    // Extract operational data
    final operational = json['operational'] as Map<String, dynamic>?;

    return MeterModel(
      id: json['meter_id'] ?? json['id'] ?? '',
      name:
          metadata?['notes'] ??
          'Meter ${json['serial_number'] ?? json['meter_id']?.toString().split('-').last ?? ''}',
      serialNumber: json['serial_number'] ?? '',
      meterIp: network?['ip_address'] ?? json['meterIp'] ?? '',
      port: network?['port'] ?? json['port'] ?? 4059,
      status: json['status'] ?? 'inactive',
      manufacturer: json['manufacturer'],
      model: json['model'],
      location: metadata?['location'] ?? json['location'],
      notes: metadata?['notes'],
      authentication: null, // TODO: Handle clients array properly
      lastSyncTime: json['lastSyncTime'],
      lastSyncData: json['lastSyncData'],
      createdAt:
          metadata?['created_at'] != null
              ? DateTime.parse(metadata!['created_at'])
              : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          metadata?['updated_at'] != null
              ? DateTime.parse(metadata!['updated_at'])
              : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      connectionStatus:
          operational?['connection_status'] ?? json['connectionStatus'],
      lastReadTime:
          operational?['last_read_timestamp'] != null
              ? DateTime.parse(operational!['last_read_timestamp'])
              : json['lastReadTime'] != null
              ? DateTime.parse(json['lastReadTime'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serialNumber': serialNumber,
      'meterIp': meterIp,
      'port': port,
      'status': status,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (model != null) 'model': model,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      if (authentication != null) 'authentication': authentication!.toJson(),
      'lastSyncTime': lastSyncTime,
      'lastSyncData': lastSyncData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (connectionStatus != null) 'connectionStatus': connectionStatus,
      if (lastReadTime != null) 'lastReadTime': lastReadTime!.toIso8601String(),
    };
  }

  bool get isActive => status == 'active';
  bool get hasSyncData => lastSyncData != null && lastSyncData!.isNotEmpty;

  // Check if meter has write capabilities (requires high auth)
  bool get canWrite => authentication?.canWrite ?? false;

  // Get available authentication level
  String get authLevel => authentication?.bestAvailableLevel ?? 'None';
}
