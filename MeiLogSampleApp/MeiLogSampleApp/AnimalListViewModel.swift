//
//  AnimalListViewModel.swift
//  MeiLogSampleApp
//
//  Created by Mei Yu on 11/2/24.
//

import Foundation
import MeiAnalytics

class AnalaticsLogs {
    var viewInteractionEvent = SearchEvent.duration.searchViewInteraction.event
    var searchInputPressed = SearchEvent.immediate.searchInputFieldKeyPressed.event
    let sreenName: String
    
    init(screenName: String) {
        self.sreenName = screenName
        viewInteractionEvent.payload.set("screen", screenName)
        searchInputPressed.payload.set("screen", screenName)
        viewInteractionEvent.payload.set("textfield", "Search")
    }
}


struct Animal: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
}

class AnimalListViewModel: ObservableObject {
    
    let logs = AnalaticsLogs(screenName: "Animal List")
    
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                var event = logs.searchInputPressed
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
