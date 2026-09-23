import Foundation

/// An in-memory ``KeychainStoring`` for tests and previews.
public final class FakeKeychainStore: KeychainStoring, @unchecked Sendable {
  private let lock = NSLock()
  private var items: [String: Data]
  /// When set, every operation throws this error.
  public var failure: KeychainError?

  public init(items: [String: Data] = [:]) {
    self.items = items
  }

  /// A snapshot of every stored item keyed by account.
  public var storedItems: [String: Data] {
    lock.withLock { items }
  }

  public func data(forAccount account: String) throws -> Data? {
    try lock.withLock {
      if let failure { throw failure }
      return items[account]
    }
  }

  public func setData(_ data: Data, forAccount account: String) throws {
    try lock.withLock {
      if let failure { throw failure }
      items[account] = data
    }
  }

  public func removeValue(forAccount account: String) throws {
    try lock.withLock {
      if let failure { throw failure }
      items[account] = nil
    }
  }
}
