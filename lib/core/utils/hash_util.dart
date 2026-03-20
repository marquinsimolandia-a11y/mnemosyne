import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashUtil {
  HashUtil._();

  /// Returns SHA-256 hex digest of [value].
  static String sha256Of(String value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  /// Compares [input] against a known [storedHash] (SHA-256 hex).
  static bool verify(String input, String storedHash) =>
      sha256Of(input) == storedHash;
}
