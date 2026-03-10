# Nuthatch: Architecture & Design

## Overview
Nuthatch is a lightweight Swift library designed to simplify the persistent storage of `Codable` types. It provides a suite of Swift Property Wrappers that abstract the complexity of interacting with different storage mediums such as `UserDefaults`, the local file system, and iCloud's `NSUbiquitousKeyValueStore`.

## High-Level Architecture
Nuthatch follows a decorator-like pattern using Property Wrappers to intercept property access and delegate persistence to specialized storage handlers. The architecture is modular, allowing developers to choose the appropriate storage strategy based on the data's size, complexity, and synchronization requirements.

### Technical Stack
- **Language**: Swift 5.7+
- **Framework**: Foundation
- **Build System**: Swift Package Manager (SPM)
- **Platforms**: iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 6.0+

## Core Design Philosophies
- **Zero Boilerplate**: Persistence is achieved by simply decorating a property.
- **Type Safety**: Leverages Swift's `Codable` protocol to ensure data integrity during serialization.
- **Convention over Configuration**: Provides sensible defaults (like the Documents directory for file storage) while allowing customization where necessary.
- **Native-First**: Relies exclusively on Apple's Foundation framework, ensuring minimal overhead and maximum compatibility with the ecosystem.

## Components & Data Persistence Strategies

### 1. `UserDefault<T>`
- **Medium**: `UserDefaults`
- **Use Case**: Small configuration flags, user preferences, and simple state.
- **Mechanism**: Encodes `Codable` types into `Data` objects before storing them in `UserDefaults`. This bypasses the traditional limitations of `UserDefaults` regarding complex types.

### 2. `UbiquitousKeyValueStored<T>`
- **Medium**: `UserDefaults` + `NSUbiquitousKeyValueStore` (iCloud)
- **Use Case**: Settings that need to be synchronized across a user's devices (e.g., theme preference, premium status).
- **Mechanism**: Dual-writes to both local `UserDefaults` and the iCloud key-value store. It provides a `sync()` method to manually trigger a pull from iCloud to local storage.

### 3. `LocalStore` & `LocalStoreBacked<T>`
- **Medium**: Local File System (`FileManager`)
- **Use Case**: Larger data structures, collections, or documents that are too heavy for `UserDefaults`.
- **Mechanism**:
    - `LocalStore`: A utility class that handles raw JSON serialization to and from specific file URLs.
    - `LocalStoreBacked`: A property wrapper that maps a property to a specific file in the application's `Documents` directory.

## Technical Specifications

### Data Models
Any type conforming to the `Codable` protocol can be persisted. This includes primitives, structs, enums, and classes, provided their nested properties are also `Codable`.

### Error Handling
The library adopts a "Graceful Failure" strategy. If a read operation fails due to corruption or missing data, the system returns a developer-provided `defaultValue`. Failures are currently logged to the console using `print` statements to aid in debugging without crashing the host application.

### Concurrency Model
Operations are currently **synchronous**. Persistence happens on the thread where the property is accessed or modified. For standard UI settings or small files, this provides a simple and predictable mental model. For extremely large datasets, developers are encouraged to handle property access on background queues.

### State Management
- **Memoization**: `LocalStoreBacked` includes a memoization field to optimize read performance, reducing redundant disk I/O when the data is accessed frequently.

## Testing Infrastructure
The project uses the **Swift Testing** framework (introduced in 2024) to ensure reliability.
- **Unit Tests**: Located in `Tests/NuthatchTests/`.
- **Strategy**: Tests focus on verifying:
    - Default value fallback.
    - Correct serialization/deserialization of complex types (e.g., Arrays).
    - Proper handling of `nil` values.
    - Integration with `UserDefaults` using custom suite names to avoid polluting the main application state.

## Security, Scalability & Performance

### Security
Nuthatch relies on the native sandbox security provided by iOS and macOS. Data stored in the `Documents` directory or `UserDefaults` is protected by standard OS-level encryption. The library does not currently implement additional application-level encryption (e.g., Keychain integration).

### Performance
- **UserDefaults**: Fast for small keys; performance degrades with very large values.
- **LocalStore**: Optimized for larger payloads. By using the `Documents` directory, it ensures data is backed up to iCloud/iTunes unless specified otherwise.
- **iCloud Sync**: `UbiquitousKeyValueStored` is subject to Apple's rate limits and size constraints (1MB total limit for the entire store).

### Scalability
The modular nature of the property wrappers allows for easy expansion. Future iterations could include a `Keychain` backed wrapper or a `CoreData` backed wrapper while maintaining the same ergonomic API.
