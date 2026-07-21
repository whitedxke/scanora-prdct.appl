# Repository.

The abstraction layer between UI / Controllers and storage. This is where the app's DIP boundary for data access lives.

## 1. `EventRepository` Protocol.

`Repositories/EventRepository.swift`:

```swift
protocol EventRepository: AnyObject {
    var eventsSnapshot: [Event] { get }
    var eventsPublisher: AnyPublisher<[Event], Never> { get }
    func add(_ event: Event)
    func containsEvent(withID id: Int) -> Bool
}
```

Controllers and screens only ever depend on this protocol — never on a concrete repository type.

## 2. Implementations.

- **`MemoryEventRepository`** — in-memory `@Published` array, no persistence. Useful for previews and tests where disk I/O isn't wanted.
- **`PersistentEventRepository`** — the production implementation. Wraps an `EventStore` (defaults to `JSONFileEventStore.appDocumentsStore()`) and a `Logger` (defaults to `ConsoleLogger`). Loads from the store on `init`, saves to the store on every `add(_:)`. See [Persistence.md](Persistence.md) for the storage details.

Both implementations expose the same `eventsPublisher` (Combine `AnyPublisher<[Event], Never>`, backed by `@Published`), so consumers don't need to know which one they're talking to.

## 3. How Controllers Consume It.

- `ScannerController` calls `eventRepository.add(event)` after a QR-code resolves successfully, and reads `eventRepository.eventsSnapshot` to build the `existingIDs` set used for duplicate detection (see [Scanner.md](Scanner.md)).
- `EventsListController` subscribes to `eventRepository.eventsPublisher` via Combine and re-applies its active / completed filter every time the underlying event list changes.

Neither controller knows whether it's talking to `MemoryEventRepository` or `PersistentEventRepository` — that's decided once, at composition time.

## 4. Composition.

`ScanoraApp` owns a single `PersistentEventRepository` instance as a `@StateObject` and passes it down through `AppNavigation` to both the scanner and events-list scenes. Each scene builds its own controller from that same shared instance, so every screen observes one consistent source of truth.

## 5. Adding a Backend.

1. Implement `RemoteEventRepository: EventRepository` (network calls behind the same four members).
2. Wire it into `ScanoraApp` in place of `PersistentEventRepository`.

No changes are required in `Controllers`, `Screens`, or `Models` — they only ever depended on the `EventRepository` protocol.
