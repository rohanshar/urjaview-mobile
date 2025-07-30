/// OBIS code definitions for real-time meter data
class RealtimeObisConstants {
  // Voltage OBIS codes
  static const List<String> voltageCodes = [
    '1.0.32.7.0.255', // L1 Voltage
    '1.0.52.7.0.255', // L2 Voltage
    '1.0.72.7.0.255', // L3 Voltage
    '1.0.12.7.0.255', // Average Voltage
  ];
  
  // Current OBIS codes
  static const List<String> currentCodes = [
    '1.0.31.7.0.255', // L1 Current
    '1.0.51.7.0.255', // L2 Current
    '1.0.71.7.0.255', // L3 Current
    '1.0.11.7.0.255', // Total Current
  ];
  
  // Power Factor OBIS codes
  static const List<String> powerFactorCodes = [
    '1.0.13.7.0.255', // Total Power Factor
    '1.0.33.7.0.255', // L1 Power Factor
    '1.0.53.7.0.255', // L2 Power Factor
    '1.0.73.7.0.255', // L3 Power Factor
  ];
  
  // Frequency OBIS code
  static const List<String> frequencyCodes = [
    '1.0.14.7.0.255', // Frequency
  ];
  
  // Active Power OBIS codes
  static const List<String> activePowerCodes = [
    '1.0.1.7.0.255',  // Total Active Power
    '1.0.21.7.0.255', // L1 Active Power
    '1.0.41.7.0.255', // L2 Active Power
    '1.0.61.7.0.255', // L3 Active Power
  ];
  
  // Energy OBIS codes
  static const List<String> energyCodes = [
    '1.0.1.8.0.255',  // Import Energy
    '1.0.2.8.0.255',  // Export Energy
  ];
  
  // Reactive Power OBIS codes
  static const List<String> reactivePowerCodes = [
    '1.0.3.7.0.255',  // Total Reactive Power
    '1.0.23.7.0.255', // L1 Reactive Power
    '1.0.43.7.0.255', // L2 Reactive Power
    '1.0.63.7.0.255', // L3 Reactive Power
  ];
  
  // Apparent Power OBIS codes
  static const List<String> apparentPowerCodes = [
    '1.0.9.7.0.255',  // Total Apparent Power
    '1.0.29.7.0.255', // L1 Apparent Power
    '1.0.49.7.0.255', // L2 Apparent Power
    '1.0.69.7.0.255', // L3 Apparent Power
  ];
  
  // All OBIS codes combined
  static List<String> get allCodes => [
    ...voltageCodes,
    ...currentCodes,
    ...powerFactorCodes,
    ...frequencyCodes,
    ...activePowerCodes,
    ...energyCodes,
    ...reactivePowerCodes,
    ...apparentPowerCodes,
  ];
  
  // OBIS code to name mapping
  static const Map<String, String> obisNames = {
    // Voltage
    '1.0.32.7.0.255': 'L1 Voltage',
    '1.0.52.7.0.255': 'L2 Voltage',
    '1.0.72.7.0.255': 'L3 Voltage',
    '1.0.12.7.0.255': 'Average Voltage',
    // Current
    '1.0.31.7.0.255': 'L1 Current',
    '1.0.51.7.0.255': 'L2 Current',
    '1.0.71.7.0.255': 'L3 Current',
    '1.0.11.7.0.255': 'Total Current',
    // Power Factor
    '1.0.13.7.0.255': 'Total Power Factor',
    '1.0.33.7.0.255': 'L1 Power Factor',
    '1.0.53.7.0.255': 'L2 Power Factor',
    '1.0.73.7.0.255': 'L3 Power Factor',
    // Frequency
    '1.0.14.7.0.255': 'Frequency',
    // Active Power
    '1.0.1.7.0.255': 'Total Active Power',
    '1.0.21.7.0.255': 'L1 Active Power',
    '1.0.41.7.0.255': 'L2 Active Power',
    '1.0.61.7.0.255': 'L3 Active Power',
    // Energy
    '1.0.1.8.0.255': 'Import Energy',
    '1.0.2.8.0.255': 'Export Energy',
    // Reactive Power
    '1.0.3.7.0.255': 'Total Reactive Power',
    '1.0.23.7.0.255': 'L1 Reactive Power',
    '1.0.43.7.0.255': 'L2 Reactive Power',
    '1.0.63.7.0.255': 'L3 Reactive Power',
    // Apparent Power
    '1.0.9.7.0.255': 'Total Apparent Power',
    '1.0.29.7.0.255': 'L1 Apparent Power',
    '1.0.49.7.0.255': 'L2 Apparent Power',
    '1.0.69.7.0.255': 'L3 Apparent Power',
  };
  
  static String getParameterName(String obisCode) {
    return obisNames[obisCode] ?? obisCode;
  }
}