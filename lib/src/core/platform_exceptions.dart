// Platform-specific network exceptions
//
// Provides a cross-platform abstraction for network exceptions.
// On web/WASM, SocketException doesn't exist, so we use a stub.

// Conditional imports for platform-specific exceptions
import 'package:lenco_flutter/src/core/platform_exceptions_stub.dart'
    if (dart.library.io) 'package:lenco_flutter/src/core/platform_exceptions_io.dart'
    as platform;

/// Exception thrown when an operation times out
///
/// This is from dart:async and works on all platforms.
export 'dart:async' show TimeoutException;

/// Exception thrown for socket-related errors
///
/// On platforms with dart:io, this is a real SocketException.
/// On web/WASM, this is a stub that behaves similarly.
typedef SocketException = platform.SocketExceptionStub;
