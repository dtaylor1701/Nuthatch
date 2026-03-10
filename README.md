# Nuthatch

Nuthatch is a lightweight Swift package that provides a suite of property wrappers and utilities for simplifying persistent storage of `Codable` types across different mediums, including `UserDefaults`, iCloud's `NSUbiquitousKeyValueStore`, and the local file system.

## Features

- **`UserDefault`**: A property wrapper that automatically encodes and decodes any `Codable` type for storage in `UserDefaults`.
- **`UbiquitousKeyValueStored`**: Synchronizes data between `UserDefaults` and iCloud's `NSUbiquitousKeyValueStore`, ensuring your settings are available across all user devices.
- **`LocalStore` & `LocalStoreBacked`**: Provides a convenient way to persist larger `Codable` objects directly to files in the application's documents directory.

## Installation

### Swift Package Manager

Add Nuthatch to your project via Swift Package Manager. In Xcode, select `File` > `Add Packages...` and enter the repository URL.

Alternatively, add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/Nuthatch.git", from: "1.0.0")
]
```

## Usage

### UserDefault

Easily store `Codable` types in `UserDefaults`.

```swift
struct Settings {
    @UserDefault("user_profile", defaultValue: nil)
    var profile: Profile?
}
```

### UbiquitousKeyValueStored (iCloud Sync)

Keep simple key-value data in sync across devices using iCloud.

```swift
struct AppPreferences {
    @UbiquitousKeyValueStored("theme_color", defaultValue: "blue")
    var themeColor: String?
}
```

### LocalStoreBacked

Persist more complex data structures to the local file system.

```swift
struct AppData {
    @LocalStoreBacked(path: "user_data.json", defaultValue: [])
    var items: [Item]
}
```

### LocalStore Utility

You can also use the `LocalStore` class directly for manual file operations.

```swift
let items = [Item(name: "Example")]
LocalStore.write(item: items, to: myURL)

if let retrievedItems = LocalStore.read(type: [Item].self, from: myURL) {
    print(retrievedItems)
}
```

## Components

The package is organized into several key components:

- **Storage Wrappers**: 
    - `UserDefault.swift`: `Codable` support for standard local preferences.
    - `UbiquitousKeyValueStored.swift`: Cross-device synchronization via iCloud.
- **File System Storage**:
    - `LocalStore.swift`: Low-level file I/O utilities for the documents directory.
    - `LocalStoreBacked.swift`: Property wrapper for transparent file-based persistence.

## Dependencies

Nuthatch has **no external dependencies** and relies solely on Apple's Foundation framework.

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.7+
