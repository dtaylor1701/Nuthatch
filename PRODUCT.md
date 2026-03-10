I will read the `README.md` and `DESIGN.md` files to understand the project's purpose and design goals.
# Product Manifesto: Nuthatch

## 1. Product Vision & Core Objectives
**Vision:** To make data persistence in Swift as effortless and intuitive as declaring a variable.

Nuthatch aims to bridge the gap between simple `UserDefaults` and complex database solutions like Core Data or SwiftData. Many developers struggle with the boilerplate required to store `Codable` types, sync settings across iCloud, or manage local JSON files. Nuthatch provides a unified, property-wrapper-based API that handles the "how" of persistence, allowing developers to focus on the "what" of their application logic.

### Core Objectives:
*   **Zero-Boilerplate Persistence:** Eliminate manual encoding/decoding logic for standard storage tasks.
*   **Type-Safe by Default:** Leverage Swift’s strong typing and `Codable` protocol to ensure data integrity.
*   **Platform Native:** Build exclusively on Apple’s Foundation framework to ensure stability, performance, and zero external dependencies.
*   **Progressive Complexity:** Provide a path from simple local settings (`UserDefault`) to cross-device sync (`UbiquitousKeyValueStored`) and structured file storage (`LocalStore`).

---

## 2. Target Audience & User Personas
Nuthatch is designed for Swift developers building apps across the Apple ecosystem (iOS, macOS, tvOS, watchOS).

### User Personas:
*   **The Indie Developer:** Needs to quickly implement "Settings" and "Pro Status" syncing across iPhone and Mac without setting up a custom backend or navigating the complexities of CloudKit's record-based API.
*   **The Feature Engineer:** Working on a large codebase and wants a standardized, clean way to persist feature flags or minor UI state without polluting the global state or writing repetitive serialization code.
*   **The Prototyper:** Needs to save a list of model objects to disk quickly to test an idea, preferring a simple `@LocalStoreBacked` wrapper over implementing a full database schema.

---

## 3. Feature Roadmap

### Short-Term (Current Focus)
*   **Stability & Refinement:** Hardening the `UbiquitousKeyValueStored` synchronization logic and improving error reporting.
*   **Documentation:** Expanding usage examples and best practices for conflict resolution in iCloud sync.
*   **Performance:** Optimizing the `LocalStore` memoization to minimize disk I/O on high-frequency property access.

### Medium-Term (Next 6–12 Months)
*   **Keychain Integration:** Introducing a `@SecureStore` property wrapper for sensitive data (API keys, tokens) using the iOS/macOS Keychain.
*   **Observation & Reactivity:** Adding support for Swift Observation (or Combine) to allow UI components to automatically refresh when a persisted value changes.
*   **Async/Await Support:** Providing asynchronous variants for `LocalStore` operations to prevent blocking the main thread during large file writes.

### Long-Term (Visionary)
*   **Lightweight Migrations:** A simple versioning system for `Codable` types to handle schema changes gracefully.
*   **Plug-and-Play Backends:** Allowing developers to inject custom storage engines (e.g., SQLite, encrypted files) while keeping the same Property Wrapper API.
*   **Cross-Platform Extensions:** Exploring potential for Swift on Server or Linux-compatible storage providers.

---

## 4. Feature Prioritization & Core Value
We prioritize features based on the **"Friction-to-Value"** ratio. 

*   **Why `UserDefault` is core:** It solves the most common developer complaint—`UserDefaults` doesn't natively support custom `Codable` structs.
*   **Why `Ubiquitous` is core:** iCloud Key-Value sync is often overlooked because the native API is string-keyed and event-based. Nuthatch makes it "set and forget."
*   **Why we avoid "Heavy" features:** We will not implement complex querying or relational mapping. If a user needs those, they should use SwiftData. Nuthatch wins by staying lightweight and focused on **Key-Value** and **Document** patterns.

---

## 5. Iteration Strategy
Our development is driven by **Developer Experience (DX)**.

*   **Feedback Loops:** We monitor GitHub Issues and community discussions to identify "boilerplate hot-spots."
*   **Experimentation:** New storage wrappers are first introduced as internal utilities in sample apps to verify their ergonomics before being promoted to the core package.
*   **Dogfooding:** The maintainers use Nuthatch in production apps to ensure the library handles real-world edge cases like app lifecycle changes and background synchronization.

---

## 6. Release Strategy & Onboarding
*   **Release Cadence:** Semantic Versioning (SemVer) is strictly followed. Minor updates include new storage types; patches fix sync edge cases.
*   **Onboarding Goal:** A developer should be able to integrate Nuthatch and persist their first custom struct in **under 2 minutes**.
*   **Documentation:** Every property wrapper must include a "Quick Start" code snippet in the README.

---

## 7. Success Metrics & KPIs
*   **Adoption:** Number of unique Swift packages or apps listing Nuthatch as a dependency.
*   **Efficiency:** Reduction in lines of code (LoC) for persistence layers in projects that migrate to Nuthatch.
*   **Reliability:** Zero reported cases of data loss due to serialization errors (validated through exhaustive unit testing of edge-case JSON payloads).
*   **Performance:** Overhead of property wrappers remaining under 1ms for standard `UserDefaults` operations.

---

## 8. Future Opportunities
As the Swift language evolves (e.g., Macros, Ownership), Nuthatch has the opportunity to further reduce boilerplate. 
*   **Macros:** Transitioning from Property Wrappers to Swift Macros could allow for even more compile-time safety and better integration with `Observable` types.
*   **Privacy:** Automated handling of "do not back up" attributes for local files to help developers comply with Apple's App Store privacy and storage guidelines automatically.
