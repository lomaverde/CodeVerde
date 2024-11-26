
# Mission of CodeVerde Project

The mission of CodeVerde is to empower developers to build scalable, maintainable, and modular systems by bridging the gap between theoretical concepts and practical application of architectural principles and design patterns.

By providing clear examples, reusable templates, and intuitive tools, CodeVerde aims to simplify complex design challenges, foster best practices, and inspire innovation.  Our goal is to build a go-to resource that helps developers of all skill levels to craft clean,
efficient, and future-proof codebases.

Feel free to contribute or share your thoughts! Together, we can advance the art of software design and make complex systems simpler and more accessible for everyone.

**Table of Contents**

- [Mission of CodeVerde Project](#mission-of-codeverde-project)
- [Living Projects:](#living-projects)
  - [MeiAnalytics](#meianalytics)
    - [1. Features](#1-features)
    - [2. Installation](#2-installation)
    - [3. Usage](#3-usage)
      - [3.1. Importing MeiAnalytic](#31-importing-meianalytic)
      - [3.2. Basic Setup](#32-basic-setup)
      - [3.3. Tracking Events](#33-tracking-events)
    - [4. High Level Design](#4-high-level-design)
      - [4.1. Class Diagrams](#41-class-diagrams)
      - [4.2. Sequence Diagrams](#42-sequence-diagrams)
        - [4.2.1. Log event with duration](#421-log-event-with-duration)
        - [4.2.2. Upload events to server](#422-upload-events-to-server)
    - [5. Architecture and Design Patterns](#5-architecture-and-design-patterns)
      - [Design Patterns Used](#design-patterns-used)
        - [Creational](#creational)
        - [Structural](#structural)
        - [Behavioral](#behavioral)
        - [Concurrency](#concurrency)
        - [Patterns in SwiftUI](#patterns-in-swiftui)
    - [6. Framework Open Tasks](#6-framework-open-tasks)
      - [Features Improvement](#features-improvement)
        - [Analytics Framework](#analytics-framework)
      - [Technical Improvement](#technical-improvement)
- [General Concepts for iOS Applications](#general-concepts-for-ios-applications)
  - [Popular Architecture Patterns](#popular-architecture-patterns)
  - [Design Patterns](#design-patterns)
  - [Anti-Patterns](#anti-patterns)
  - [SOLID Design Principles](#solid-design-principles)
- [CodeVerde Project Roadmap](#codeverde-project-roadmap)
  - [Refine Living projects](#refine-living-projects)
  - [Add details for design patterns](#add-details-for-design-patterns)
  - [Link design patterns to code in projects](#link-design-patterns-to-code-in-projects)
  - [Add a SwiftUI framework](#add-a-swiftui-framework)
- [Reference](#reference)
  - [Tools are used in the project](#tools-are-used-in-the-project)
    - [IDEs](#ides)
      - [Xcode](#xcode)
      - [Visual Studio Code](#visual-studio-code)
      - [Markdown All in One](#markdown-all-in-one)
    - [Design and modeling tool](#design-and-modeling-tool)
      - [Mermaid Chart](#mermaid-chart)

# Living Projects:

## MeiAnalytics

**MeiAnalytics** is a lightweight and flexible analytics framework for tracking user interactions, 
events, and custom metrics in iOS applications. 

### 1. Features

- **Event Tracking**: Track custom events and user interactions with ease.
- **Session Management**: Measure the duration of sessions, screen views, and actions.
- **Configurable Logging**: Dynamically enable or disable logging as needed.
- **High Performance**: Process and send events to the server in background process.
- **Reliability**: Unprocessed events are persisted locally to prevent data loss.

### 2. Installation

To integrate MeiAnalytics with Swift Package Manager:

2.1. In Xcode, Add 'MeiAnalytics' project to your workspace
2.2. Under your application project **General > Frameworks, Libraries, and Embedded Content**. 
2.3. Add MeiAnalytics.framework.

### 3. Usage

#### 3.1. Importing MeiAnalytic

Import MeiAnalytics in your Swift files:

```swift
import MeiAnalytics
```

#### 3.2. Basic Setup

Enable Tracking if needed:

```swift

MeiAnalytics.shared.isEnabled = true

```

#### 3.3. Tracking Events

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

### 4. High Level Design

#### 4.1. Class Diagrams

![Main class diagram](Documentation/Assets/MeiAnalytics-main-classes.png)

#### 4.2. Sequence Diagrams

##### 4.2.1. Log event with duration

![Log event with duration diagram](Documentation/Assets/Sequence-Log_DurationEvent.png)
Sequence-Log_DurationEvent

##### 4.2.2. Upload events to server

![Upload events to server diagram](Documentation/Assets/Sequence-UploadEvents.png)

### 5. Architecture and Design Patterns

####  Design Patterns Used 

##### Creational 

- *Singleton*
- *Dependency Injection*

##### Structural 

- *Facade*

##### Behavioral

- *Strategy*

##### Concurrency 

- *Reader-Writer Lock*

##### Patterns in SwiftUI

- *Declaratie UI Programming*

- *Functional Reactive Programming*

- *State-Driven*

- *Unidirectional Data Flow*

- *MVVM*

### 6. Framework Open Tasks

#### Features Improvement

##### Analytics Framework

1. Framework Configuration by client
    - 1.1 Server Endpoints
    - 1.2 Payload transformation

2. Local Logging
    - 2.1 log to console
    - 2.2 log to file
    - 2.3 Export 
    - 2.4 Report with charts

#### Technical Improvement

1. Move dependances to Context objects
2. Add Unit tests
3. Add UI automation tests.


# General Concepts for iOS Applications

## Popular Architecture Patterns 

## Design Patterns

## Anti-Patterns

## SOLID Design Principles


# CodeVerde Project Roadmap
## Refine Living projects
## Add details for design patterns 
## Link design patterns to code in projects
## Add a SwiftUI framework

# Reference
## Tools are used in the project
### IDEs
#### Xcode
#### Visual Studio Code
#### Markdown All in One

### Design and modeling tool
#### [Mermaid Chart](https://www.mermaidchart.com/)