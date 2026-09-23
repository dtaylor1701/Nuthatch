import Foundation

/// Stores small secrets (API keys, tokens, cookies) keyed by account name.
public protocol KeychainStoring: Sendable {
  /// The stored data for `account`, or `nil` when nothing is stored.
  func data(forAccount account: String) throws -> Data?
  /// Stores `data` for `account`, replacing any existing value.
  func setData(_ data: Data, forAccount account: String) throws
  /// Removes the value for `account`. Removing a missing value succeeds.
  func removeValue(forAccount account: String) throws
}

extension KeychainStoring {
  /// The stored UTF-8 string for `account`, or `nil` when nothing is stored.
  public func string(forAccount account: String) throws -> String? {
    guard let data = try data(forAccount: account) else { return nil }
    guard let string = String(data: data, encoding: .utf8) else { throw KeychainError.invalidEncoding }
    return string
  }

  /// Stores `string` as UTF-8, or removes the value when `string` is empty.
  public func setString(_ string: String, forAccount account: String) throws {
    if string.isEmpty {
      try removeValue(forAccount: account)
    } else {
      try setData(Data(string.utf8), forAccount: account)
    }
  }
}
