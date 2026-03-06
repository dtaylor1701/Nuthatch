import Testing
import Foundation
@testable import Nuthatch

@Suite("UbiquitousKeyValueStored Tests")
struct UbiquitousKeyValueStoredTests {
  @Test func defaultValue() {
    let suiteName = UUID().uuidString
    let userDefaults = UserDefaults(suiteName: suiteName)!
    var wrapper = UbiquitousKeyValueStored<Int>("test", defaultValue: 1, userDefaults: userDefaults)

    wrapper.wrappedValue = nil

    #expect(wrapper.wrappedValue == 1)
    userDefaults.removePersistentDomain(forName: suiteName)
  }

  @Test func nilDefaultValue() {
    let suiteName = UUID().uuidString
    let userDefaults = UserDefaults(suiteName: suiteName)!
    var wrapper = UbiquitousKeyValueStored<Int>("test", defaultValue: nil, userDefaults: userDefaults)

    wrapper.wrappedValue = nil

    #expect(wrapper.wrappedValue == nil)
    userDefaults.removePersistentDomain(forName: suiteName)
  }

  @Test func array() {
    let suiteName = UUID().uuidString
    let userDefaults = UserDefaults(suiteName: suiteName)!
    var wrapper = UbiquitousKeyValueStored<[Int]>("test", defaultValue: nil, userDefaults: userDefaults)

    wrapper.wrappedValue = [1, 2, 3]

    #expect(wrapper.wrappedValue == [1, 2, 3])
    userDefaults.removePersistentDomain(forName: suiteName)
  }
}
