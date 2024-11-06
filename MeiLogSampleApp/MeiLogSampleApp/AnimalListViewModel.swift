//
//  AnimalListViewModel.swift
//  MeiLogSampleApp
//
//  Created by Mei Yu on 11/2/24.
//

import Foundation
import MeiAnalytics

class AnalaticsLogs {
    var inputFieldFocused = SearchEvent.duration.searchInputFieldFocused.event
    var inputFieldKeyPressed = SearchEvent.immediate.searchInputFieldKeyPressed.event
    var submittedToResults = SearchEvent.duration.searchFromSubmittedToResultsDisplayed.event
    var viewInteraction = SearchEvent.duration.searchViewInteraction.event
    
    private var allEvents: [any EventLoggable] {
        [inputFieldFocused,
         inputFieldKeyPressed,
         submittedToResults,
         viewInteraction
         ]
    }
    
    let sreenName: String
    
    init(screenName: String) {
        self.sreenName = screenName
        
        // Initialized all the events
        for event in allEvents {
            event.payload.set("screenName", screenName)
        }
    }
}

struct Animal: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let emoji: String
    var detail: String = ""
    var fondness: Int = 3
}

class AnimalListViewModel: ObservableObject {
    
    let logs = AnalaticsLogs(screenName: "Animal List")
    
    func markedAsDisplayed(animal: Animal) {
        if animal.id == filteredAnimals.last?.id {
            logs.submittedToResults.log()
        }
    }
    
    func update(animal: Animal) {
        // find index of animal
        // replace
        var foundIndex = -1
        for (index, value) in animals.enumerated() {
            if value.id == animal.id {
                foundIndex = index
            }
        }
        if foundIndex != -1 {
            animals[foundIndex] = animal
        }
    }
    
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                logs.submittedToResults.start()
                var event = logs.inputFieldKeyPressed
                event.payload.set("searchText", searchText)
                event.log()
                print("didSet searchText: \(searchText)")
            }
        }
    }
    
    @Published var animals: [Animal] = [
        Animal(name: "Panda", emoji: "🐼"),
        Animal(name: "Ant", emoji: "🐜"),
        Animal(name: "Badger", emoji: "🦡"),
        Animal(name: "Bat", emoji: "🦇"),
        Animal(name: "Bear", emoji: "🐻"),
        Animal(name: "Bee", emoji: "🐝"),
        Animal(name: "Bird", emoji: "🐦"),
        Animal(name: "Butterfly", emoji: "🦋"),
        Animal(name: "Camel", emoji: "🐪"),
        Animal(name: "Cat", emoji: "🐱"),
        Animal(name: "Chick", emoji: "🐥"),
        Animal(name: "Chicken", emoji: "🐔"),
        Animal(name: "Cow", emoji: "🐮"),
        Animal(name: "Crab", emoji: "🦀"),
        Animal(name: "Crocodile", emoji: "🐊"),
        Animal(name: "Deer", emoji: "🦌"),
        /*
        Animal(name: "Dinosaur", emoji: "🦖"),
        Animal(name: "Dog", emoji: "🐶"),
        Animal(name: "Duck", emoji: "🦆"),
        Animal(name: "Elephant", emoji: "🐘"),
        Animal(name: "Fish", emoji: "🐟"),
        Animal(name: "Fox", emoji: "🦊"),
        Animal(name: "Frog", emoji: "🐸"),
        Animal(name: "Giraffe", emoji: "🦒"),
        Animal(name: "Goat", emoji: "🐐"),
        Animal(name: "Gorilla", emoji: "🦍"),
        Animal(name: "Hedgehog", emoji: "🦔"),
        Animal(name: "Horse", emoji: "🐴"),
        Animal(name: "Kangaroo", emoji: "🦘"),
        Animal(name: "Koala", emoji: "🐨"),
        Animal(name: "Ladybug", emoji: "🐞"),
        Animal(name: "Lion", emoji: "🦁"),
        Animal(name: "Llama", emoji: "🦙"),
        Animal(name: "Monkey", emoji: "🐒"),
        Animal(name: "Octopus", emoji: "🐙"),
        Animal(name: "Owl", emoji: "🦉"),
        Animal(name: "Oyster", emoji: "🦪"),
        Animal(name: "Panda", emoji: "🐼"),
        Animal(name: "Parrot", emoji: "🦜"),
        Animal(name: "Peacock", emoji: "🦚"),
        Animal(name: "Penguin", emoji: "🐧"),
        Animal(name: "Pig", emoji: "🐷"),
        Animal(name: "Rabbit", emoji: "🐰"),
        Animal(name: "Raccoon", emoji: "🦝"),
        Animal(name: "Shark", emoji: "🦈"),
        Animal(name: "Sheep", emoji: "🐑"),
        Animal(name: "Shrimp", emoji: "🦐"),
        Animal(name: "Snail", emoji: "🐌"),
        Animal(name: "Snake", emoji: "🐍"),
        Animal(name: "Squid", emoji: "🦑"),
        Animal(name: "Swan", emoji: "🦢"),
        Animal(name: "Tiger", emoji: "🐯"),
        Animal(name: "Whale", emoji: "🐳"),
        Animal(name: "Wolf", emoji: "🐺"),
        Animal(name: "Zebra", emoji: "🦓"),
         */
    ]
    
    // Filtered list based on search text
    var filteredAnimals: [Animal] {
        if searchText.isEmpty {
            return animals
        } else {
            return animals.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
