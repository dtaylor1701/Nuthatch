import Testing
@testable import Nuthatch

@Suite("UbiquitousKeyValueStored Tests")
struct UbiquitousKeyValueStoredTests {
  @Test func defaultValue() {
    var wrapper = UbiquitousKeyValueStored<Int>("test", defaultValue: 1)

    wrapper.wrappedValue = nil

    #expect(wrapper.wrappedValue == 1)
  }

  @Test func nilDefaultValue() {
    var wrapper = UbiquitousKeyValueStored<Int>("test", defaultValue: nil)

    wrapper.wrappedValue = nil

    #expect(wrapper.wrappedValue == nil)
  }

  @Test func array() {
    var wrapper = UbiquitousKeyValueStored<[Int]>("test", defaultValue: nil)

    wrapper.wrappedValue = [1, 2, 3]

    #expect(wrapper.wrappedValue == [1, 2, 3])
  }
}
