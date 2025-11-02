/// Simple in-memory cache for API responses that change infrequently
class SimpleCache<T> {
  final Duration ttl;
  DateTime? _expiresAt;
  T? _cachedValue;

  SimpleCache({this.ttl = const Duration(hours: 1)});

  /// Get cached value if still valid, null otherwise
  T? get value {
    if (_cachedValue == null) return null;
    if (_expiresAt == null || DateTime.now().isAfter(_expiresAt!)) {
      _cachedValue = null;
      _expiresAt = null;
      return null;
    }
    return _cachedValue;
  }

  /// Set cached value with TTL
  void set(T value) {
    _cachedValue = value;
    _expiresAt = DateTime.now().add(ttl);
  }

  /// Clear cache
  void clear() {
    _cachedValue = null;
    _expiresAt = null;
  }

  /// Check if cache is valid
  bool get isValid =>
      _cachedValue != null &&
      (_expiresAt == null || DateTime.now().isBefore(_expiresAt!));
}
