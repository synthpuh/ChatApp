# ChatApp

![Tests](https://github.com/synthpuh/ChatApp/actions/workflows/tests.yml/badge.svg)

A clean, fully-tested iOS chat application built to demonstrate modern Swift architecture and concurrency. The app pairs **VIPER** for the UI layer with **Redux** for global state, uses **async/await** and **actors** for safe concurrency, **Combine** to bridge state to the view, and ships with a complete **unit / integration / UI** test pyramid.

> **Status:** Runs entirely on mock data today — no backend required to build, run, or test. A real networking layer (Alamofire + WebSocket) is already scaffolded behind a protocol and is the next planned step.

![Demo](docs/demo.mov)

---

## Highlights

- **VIPER + Redux** — VIPER isolates the UI module (View, Interactor, Presenter, Entity, Router); Redux owns app-wide state through a single unidirectional data flow.
- **Swift Concurrency** — `async/await` throughout the networking and interactor layers; `actor` types guard all shared mutable state against data races (verified by a concurrent-access test).
- **Combine** — the Presenter subscribes to the Redux store and maps state into view models on the main actor.
- **Protocol-driven networking** — the service layer sits behind `ChatServiceProtocol`, so the app swaps between a mock and a real implementation by changing one line.
- **Swift 6 language mode** — main-actor isolation and `Sendable` conformance handled correctly.
- **Full test pyramid** — unit tests (Swift Testing), integration tests (Swift Testing), and UI tests (XCUITest).

---

## Architecture

```
            ┌──────────────────────── Redux ────────────────────────┐
            │                                                        │
  View ──► Presenter ──► Interactor ──► dispatch(Action) ──► Reducer ──► AppState
   ▲                          │                                         │
   │                          └──► ChatService (async/await)            │
   │                                    │                               │
   └──────────── Combine ◄──── Store.$state (@Published) ◄──────────────┘
```

- **View** is passive — it renders view models and forwards user actions to the Presenter.
- **Presenter** subscribes to the store via Combine and formats `Message` entities into `ChatMessageViewModel`.
- **Interactor** holds business logic, calls the async service, and dispatches actions to the store.
- **Store / Reducer** are the single source of truth; reducers are pure functions.
- **Actors** (`MessageCache`, `ConnectionManager`) protect shared state accessed from concurrent tasks.

---

## Tech Stack

- Swift 6 / Xcode 18+
- UIKit (programmatic UI, no storyboards)
- Swift Concurrency — `async/await`, `actor`, `AsyncThrowingStream`
- Combine
- Alamofire (networking layer, behind a protocol)
- Swift Testing + XCTest / XCUITest

---

## Project Structure

```
ChatApp/
├── Core/
│   ├── Store/          # AppState, Actions, Reducer, Store (Redux)
│   ├── Networking/     # ChatService protocol, mock + Alamofire impl, errors
│   └── Actors/         # MessageCache, ConnectionManager
├── Models/             # Message, User (VIPER entities)
└── Modules/
    └── Chat/           # VIPER module
        ├── Router/
        ├── Interactor/
        ├── Presenter/
        └── View/

ChatAppTests/           # Unit + integration (Swift Testing)
├── Unit/
└── Integration/

ChatAppUITests/         # XCUITest flows
```

---

## Getting Started

### Requirements

- Xcode 16 or later (Swift Testing requires it)
- iOS 18+ deployment target

---

## Running the Tests

### Test Coverage

| Layer | What it verifies | Framework |
|---|---|---|
| **Unit** | Reducers, Store dispatch + publishing, actor safety, mock service, Presenter logic, Combine bindings | Swift Testing |
| **Integration** | Interactor + Store + service working together; live message streaming into the store | Swift Testing |
| **UI** | Message list rendering, send flow, input clearing, send-button enable/disable | XCUITest |

UI tests inject the mock service via a `--uitesting` launch argument, so they never depend on a network.

---

## Screenshots

![Demo](docs/demo.mov)

_Coming soon._

---

## Roadmap

- [ ] Wire up the real Alamofire + WebSocket backend (`ChatServiceImpl` + `ConnectionManager` are already scaffolded)
- [ ] Persist messages locally for offline support
- [ ] User authentication module (VIPER)
- [ ] Message read receipts and typing indicators

---

## License

MIT — see [LICENSE](LICENSE).
