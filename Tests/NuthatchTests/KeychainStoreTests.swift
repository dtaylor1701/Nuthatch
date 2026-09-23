import Foundation
import Testing
@testable import Nuthatch

@Suite("Keychain stores")
struct KeychainStoreTests {
  @Test("Fake store round-trips strings, treats empty as removal, and can fail")
  func fake() throws {
    let store = FakeKeychainStore()
    try store.setString("one", forAccount: "k")
    try store.setString("two", forAccount: "k")
    #expect(try store.string(forAccount: "k") == "two")
    try store.setString("", forAccount: "k")
    #expect(try store.string(forAccount: "k") == nil)
    #expect(store.storedItems.isEmpty)

    store.failure = .unexpectedStatus(-25293)
    #expect(throws: KeychainError.unexpectedStatus(-25293)) { try store.string(forAccount: "k") }
  }

  @Test("Invalid UTF-8 data surfaces an encoding error")
  func invalidEncoding() throws {
    let store = FakeKeychainStore(items: ["k": Data([0xFF, 0xFE])])
    #expect(throws: KeychainError.invalidEncoding) { try store.string(forAccount: "k") }
  }

  /// Touches the real login Keychain, so it only runs when explicitly requested.
  @Test("Keychain store adds, updates, reads, and deletes", .enabled(if: ProcessInfo.processInfo.environment["NUTHATCH_KEYCHAIN_TESTS"] != nil))
  func keychain() throws {
    let store = KeychainStore(service: "com.ramblelogic.nuthatch.tests.\(UUID().uuidString)")
    defer { try? store.removeValue(forAccount: "k") }
    try store.setString("first", forAccount: "k")
    try store.setString("second", forAccount: "k")
    #expect(try store.string(forAccount: "k") == "second")
    try store.removeValue(forAccount: "k")
    try store.removeValue(forAccount: "k")
    #expect(try store.string(forAccount: "k") == nil)
  }
}
