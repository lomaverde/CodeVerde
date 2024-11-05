# MeiAnalytics

**MeiAnalytics** is a lightweight and flexible analytics framework for tracking user interactions, events, and custom metrics in iOS applications.  In stead of taking 

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Internal Information](#internal-information)

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

struct Example {
    var name: String

    func greet() {
        print("Hello, \(name)!")
    }
}
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

## Internal Information

### class diagram

![Main class diagram](MeiAnalytics-main-classes.png)

