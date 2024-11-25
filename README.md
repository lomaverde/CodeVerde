
# Mission of the CodeVerde Project

The mission of CodeVerde is to empower developers to build scalable, maintainable, and modular systems by bridging the gap between theoretical concepts and practical application of architectural principles and design patterns.

By providing clear examples, reusable templates, and intuitive tools, CodeVerde aims to simplify complex design challenges, foster best practices, and inspire innovation. Our goal is to create a reliable resource that enables developers at all levels to craft clean, efficient, and future-proof codebases.

Together, let’s advance the art of software design and make complex systems simpler and more accessible for everyone.

# MeiAnalytics

**MeiAnalytics** is a lightweight and flexible analytics framework for tracking user interactions, events, and custom metrics in iOS applications. 

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [High Level Design](#high-level-design)
- [Roadmap](#roadmap)
- [Design Patterns](#architecture-and-design-patterns)

## Features

- **Event Tracking**: Track custom events and user interactions with ease.
- **Session Management**: Measure the duration of sessions, screen views, and actions.
- **Configurable Logging**: Dynamically enable or disable logging as needed.
- **High Performance**: Process and send events to the server in background process.
- **Reliability**: Unprocessed events are persisted locally to prevent data loss.

## Installation

To integrate MeiAnalytics with Swift Package Manager:

1. In Xcode, Add 'MeiAnalytics' project to your workspace
2. Under your application project **General > Frameworks, Libraries, and Embedded Content**. 
3. Add MeiAnalytics.framework.

## Usage

### Importing MeiAnalytic

Import MeiAnalytics in your Swift files:

```swift
import MeiAnalytics
```

### Basic Setup

Enable Tracking if needed:

```swift

MeiAnalytics.shared.isEnabled = true

```

### Tracking Events

All analytics events are associated with a custom event type and optionally some additional properties. When an event's log method is called, its timestamp and duration are recorded, creating a snapshot for further background processing. The framework will periodically send events to the server when the device is connected to the network. Any unprocessed events are saved in NSUserDefaults to preserve data in case the application restarts.

The framework supports the following two types of events:

* ImmediateEvent - an event occurs instantly and is recorded at a single point in time.
* DurationEvent - an event with a measurable duration, tracking both a start and end time.


```swift

enum SearchEvent: String {
    case searchInputFieldKeyPressed
    case searchViewInteraction
}

let searchInputFieldKeyPressedEvent = ImmediateEvent(type:SearchEvent.searchViewInteraction.rawValue)

searchInputFieldKeyPressedEvent.log()

let searchViewInteractionEvent = DurationEvent(type:SearchEvent.searchViewInteraction.rawValue)
searchViewInteractionEvent.start()
// do other stuff ...

searchViewInteractionEvent.log()

```

## High Level Design

### Class Diagrams

![Main class diagram](Documentation/Assets/MeiAnalytics-main-classes.png)

### Sequence Diagrams

#### Log event with duration

![Log event with duration diagram](Documentation/Assets/Sequence-Log_DurationEvent.png)
Sequence-Log_DurationEvent

#### Upload events to server

![Upload events to server diagram](Documentation/Assets/Sequence-UploadEvents.png)

## Architecture and Design Patterns

### Design Patterns Used 

#### Creational 

- *Singleton*
- *Dependency Injection*

#### Structural 

- *Facade*

#### Behavioral

- *Strategy*

#### Concurrency 

- *Reader-Writer Lock*

#### Patterns in SwiftUI

- *Declaratie UI Programming*

- *Functional Reactive Programming*

- *State-Driven*

- *Unidirectional Data Flow*

- *MVVM*

## Roadmap

### Features

#### Analytics Framework

1. Framework Configuration by client
    - 1.1 Server Endpoints
    - 1.2 Payload transformation

2. Local Logging
    - 2.1 log to console
    - 2.2 log to file
    - 2.3 Export 
    - 2.4 Report with charts

### Technical 

1. Move dependances to Context objects
2. Add Unit tests
3. Add UI automation tests.



