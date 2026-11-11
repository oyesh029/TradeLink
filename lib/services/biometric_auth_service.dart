import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../database/local_database_service.dart';

class BiometricAuthResult {
  final bool success;
  final String? errorMessage;
  final String? errorCode;

  BiometricAuthResult({
    required this.success,
    this.errorMessage,
    this.errorCode,
  });
}

class BiometricAuthService {
  BiometricAuthService._internal();
  static final BiometricAuthService instance = BiometricAuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  /// Check whether biometric sensors or hardware credentials are supported
  Future<bool> isBiometricsSupported() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (e) {
      debugPrint('BiometricAuthService.isBiometricsSupported error: $e');
      return false;
    }
  }

  /// Get list of available hardware biometrics (fingerprint, face, iris, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('BiometricAuthService.getAvailableBiometrics error: $e');
      return [];
    }
  }

  /// Get human-friendly label for current biometric hardware
  Future<String> getBiometricTypeLabel() async {
    try {
      final bios = await getAvailableBiometrics();
      if (bios.contains(BiometricType.face)) {
        return 'Face ID / Facial Recognition';
      } else if (bios.contains(BiometricType.fingerprint)) {
        return 'Fingerprint Scanner';
      } else if (bios.contains(BiometricType.iris)) {
        return 'Iris Scanner';
      } else if (bios.contains(BiometricType.weak) || bios.contains(BiometricType.strong)) {
        return 'Biometric Sensor';
      }
    } catch (e) {
      debugPrint('BiometricAuthService.getBiometricTypeLabel error: $e');
    }
    return kIsWeb ? 'Platform WebAuthn / Sensor' : 'Fingerprint / Face ID';
  }

  /// Perform actual biometric authentication with the device hardware
  Future<BiometricAuthResult> authenticate({
    required String reason,
    bool stickyAuth = true,
  }) async {
    try {
      final canCheck = await isBiometricsSupported();
      if (!canCheck && !kIsWeb) {
        return BiometricAuthResult(
          success: false,
          errorMessage: 'Biometric hardware sensor is not available on this device.',
        );
      }

      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        sensitiveTransaction: true,
        persistAcrossBackgrounding: stickyAuth,
      );

      return BiometricAuthResult(
        success: authenticated,
        errorMessage: authenticated ? null : 'Biometric authentication cancelled.',
      );
    } on LocalAuthException catch (e) {
      debugPrint('BiometricAuthService LocalAuthException: ${e.code} - ${e.description}');
      return BiometricAuthResult(
        success: false,
        errorMessage: e.description ?? 'Biometric verification error (${e.code.name})',
        errorCode: e.code.name,
      );
    } on PlatformException catch (e) {
      debugPrint('BiometricAuthService PlatformException: ${e.code} - ${e.message}');
      return BiometricAuthResult(
        success: false,
        errorMessage: e.message ?? 'Biometric verification failed (${e.code})',
        errorCode: e.code,
      );
    } catch (e) {
      debugPrint('BiometricAuthService general error: $e');
      return BiometricAuthResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Enroll and verify user's biometric on this device
  Future<BiometricAuthResult> enrollBiometricsForUser(String email) async {
    final result = await authenticate(
      reason: 'Scan fingerprint or Face ID to enroll biometric login on this device',
    );
    if (result.success) {
      await setBiometricEnabledForUser(email, true);
    }
    return result;
  }

  /// Check if user has enabled biometric login in TradeLink settings
  Future<bool> isBiometricEnabledForUser(String email) async {
    return await LocalDatabaseService.instance.getBiometricPreference(email);
  }

  /// Save user's biometric login preference in TradeLink local database
  Future<void> setBiometricEnabledForUser(String email, bool enabled) async {
    await LocalDatabaseService.instance.saveBiometricPreference(email, enabled);
  }
}

