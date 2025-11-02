/// Stub implementation of SocketException for web/WASM platforms
class SocketExceptionStub implements Exception {
  final String message;
  final dynamic osError;
  final String? address;
  final int? port;

  const SocketExceptionStub(
    this.message, {
    this.osError,
    this.address,
    this.port,
  });

  @override
  String toString() => 'SocketException: $message';
}
