import 'package:flutter/foundation.dart';
import '../models/meter_model.dart';
import '../services/api_service.dart';

class MeterRepository {
  final ApiService _apiService;

  MeterRepository(this._apiService);

  Future<List<MeterModel>> getMeters() async {
    try {
      final response = await _apiService.getMeters();
      debugPrint('Parsing ${response.length} meters'); // Debug log

      final meters = <MeterModel>[];
      for (var i = 0; i < response.length; i++) {
        try {
          meters.add(MeterModel.fromJson(response[i]));
        } catch (e) {
          debugPrint('Error parsing meter at index $i: $e');
          debugPrint('Meter data: ${response[i]}');
        }
      }

      return meters;
    } catch (e) {
      debugPrint('Error in getMeters repository: $e');
      rethrow;
    }
  }

  Future<MeterModel> getMeter(String meterId) async {
    final response = await _apiService.getMeter(meterId);
    return MeterModel.fromJson(response);
  }

  Future<Map<String, dynamic>> pingMeter(String meterId) async {
    try {
      return await _apiService.pingMeter(meterId);
    } catch (e) {
      debugPrint('Error in pingMeter repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> testMeterConnection(String meterId) async {
    try {
      return await _apiService.testMeterConnection(meterId);
    } catch (e) {
      debugPrint('Error in testMeterConnection repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> readMeterObjects(String meterId, List<String> obisCodes) async {
    try {
      return await _apiService.readMeterObjects(meterId, obisCodes);
    } catch (e) {
      debugPrint('Error in readMeterObjects repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> readMeterClock(String meterId) async {
    try {
      return await _apiService.readMeterClock(meterId);
    } catch (e) {
      debugPrint('Error in readMeterClock repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> setMeterClock(String meterId, {
    bool useCurrentTime = true,
    DateTime? dateTime,
  }) async {
    try {
      return await _apiService.setMeterClock(
        meterId,
        useCurrentTime: useCurrentTime,
        dateTime: dateTime,
      );
    } catch (e) {
      debugPrint('Error in setMeterClock repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> discoverObjects(String meterId) async {
    try {
      return await _apiService.discoverObjects(meterId);
    } catch (e) {
      debugPrint('Error in discoverObjects repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> readMultipleObjects(
    String meterId,
    List<Map<String, dynamic>> objects,
  ) async {
    try {
      return await _apiService.readMultipleObjects(meterId, objects);
    } catch (e) {
      debugPrint('Error in readMultipleObjects repository: $e');
      rethrow;
    }
  }
}
