import 'package:flutter/foundation.dart';
import '../../../data/models/meter_model.dart';
import '../../../data/repositories/meter_repository.dart';

class MeterProvider extends ChangeNotifier {
  final MeterRepository _meterRepository;

  List<MeterModel> _meters = [];
  bool _isLoading = false;
  String? _error;

  List<MeterModel> get meters => _meters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MeterProvider(this._meterRepository);

  Future<void> loadMeters() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _meters = await _meterRepository.getMeters();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> pingMeter(String meterId) async {
    try {
      return await _meterRepository.pingMeter(meterId);
    } catch (e) {
      debugPrint('Error pinging meter: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> testMeterConnection(String meterId) async {
    try {
      return await _meterRepository.testMeterConnection(meterId);
    } catch (e) {
      debugPrint('Error testing meter connection: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> readMeterObjects(
    String meterId,
    List<String> obisCodes,
  ) async {
    try {
      return await _meterRepository.readMeterObjects(meterId, obisCodes);
    } catch (e) {
      debugPrint('Error reading meter objects: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> readMeterClock(String meterId) async {
    try {
      return await _meterRepository.readMeterClock(meterId);
    } catch (e) {
      debugPrint('Error reading meter clock: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> setMeterClock(
    String meterId, {
    bool useCurrentTime = true,
    DateTime? dateTime,
  }) async {
    try {
      return await _meterRepository.setMeterClock(
        meterId,
        useCurrentTime: useCurrentTime,
        dateTime: dateTime,
      );
    } catch (e) {
      debugPrint('Error setting meter clock: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> discoverObjects(String meterId) async {
    try {
      return await _meterRepository.discoverObjects(meterId);
    } catch (e) {
      debugPrint('Error discovering objects: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> readMultipleObjects(
    String meterId,
    List<Map<String, dynamic>> objects,
  ) async {
    try {
      return await _meterRepository.readMultipleObjects(meterId, objects);
    } catch (e) {
      debugPrint('Error reading multiple objects: $e');
      rethrow;
    }
  }
}
