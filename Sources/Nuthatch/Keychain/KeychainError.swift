import Foundation

/// Errors raised by ``KeychainStore``.
public enum KeychainError: LocalizedError, Equatable, Sendable {
  /// A Security framework call returned an unexpected status.
  case unexpectedStatus(Int32)
  /// Stored data isn't valid UTF-8.
  case invalidEncoding

  public var errorDescription: String? {
    switch self {
    case .unexpectedStatus(let status):
      let message = SecCopyErrorMessageString(status, nil) as String? ?? "OSStatus \(status)"
      return "Keychain error: \(message)"
    case .invalidEncoding:
      return "Keychain item is not valid UTF-8 text."
    }
  }
}
