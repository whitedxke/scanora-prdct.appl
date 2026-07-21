# Persistence.

Low-level storage layer used by [`PersistentEventRepository`](Repository.md). Lives in `Repositories/EventPersistence.swift`.

## 1. Current Status.

There is no backend yet, so events are persisted to a single JSON file in the app's Documents directory. This is an intentional simplification for the current phase — see [Repository.md](Repository.md) for how this layer is swapped out once a backend exists.

## 2. `EventStore` Protocol.

```swift
protocol EventStore {
    func loadEvents() throws -> [Event]
    func saveEvents(_ events: [Event]) throws
}
```

A minimal, throwing contract — no caching, no partial updates, no pagination. Callers always load / save the full event list.

## 3. `JSONFileEventStore`.

The only current `EventStore` implementation.

- Backed by a single `fileURL`, with an injectable `JSONEncoder` / `JSONDecoder` (defaults use `.iso8601` date coding).
- `loadEvents()` returns `[]` if the file doesn't exist yet (first launch) instead of throwing.
- `saveEvents(_:)` writes with the `.atomic` option, so a save is never left half-written if the app is killed mid-write.
- `JSONFileEventStore.appDocumentsStore(fileName:)` is the default factory: writes to `scanora_events.json` under `.documentDirectory`.

## 4. Logging.

```swift
protocol Logger {
    func error(_ message: String)
}
```

`ConsoleLogger` is the only implementation — it prints to the console. There is no centralized crash / error reporting service connected yet.

## 5. Error Handling.

`PersistentEventRepository` (see [Repository.md](Repository.md)) never lets a storage error crash the app or surface to the UI:

- Load failure on init → logs via `Logger`, falls back to an empty in-memory list.
- Save failure on `add(_:)` → logs via `Logger`; the in-memory state is left ahead of what's actually on disk until the next successful save.

This is intentionally lightweight for the current phase — no retry, no backoff, no user-facing error surface for persistence failures.

## 6. Stored Shape.

Only `Event`'s stored fields are persisted: `id`, `title`, `eventDescription`, `date`, `image`. The computed `status` property is excluded from encoding (`Event` declares explicit `CodingKeys`) and is always recomputed from `date` at read time.
