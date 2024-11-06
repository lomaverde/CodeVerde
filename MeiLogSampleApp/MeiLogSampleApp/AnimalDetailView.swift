//
//  AnimalDetailView.swift
//  MeiLogSampleApp
//
//  Created by Mei Yu on 11/5/24.
//

import SwiftUI
struct AnimalDetailView: View {
    
    @State private var animal: Animal
    @ObservedObject var animalListViewModel: AnimalListViewModel
        
    init(animal: Animal,
         animalListViewModel: AnimalListViewModel) {
        self._animal = State(initialValue: animal)
        self.animalListViewModel = animalListViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(animal.emoji)
                .font(.system(size: 100))
            Text(animal.name)
                .font(.title)
            RatingView(rating: $animal.fondness)
                .padding(.bottom, 20)
            MultiLineTextView(text: $animal.detail, label: "Some fun facts about \(animal.name):", height: 300)
            Spacer()
        }
        .padding(30)
        .navigationTitle(animal.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("AnimalDetailView appeared")
        }
        .onDisappear {
            print("AnimalDetailView disappeared")
        }
        .onChange(of: animal) { oldValue, newValue in
            animalListViewModel.update(animal: newValue)
        }
    }
}

/// A configurable view that provides a multi-line text input area.
///
/// `MultiLineTextView` allows users to enter and edit longer text
///
/// - Properties:
///  - label: Label
///   - text: A binding to the entered text, which can be modified by the user.
///
/// - Example:
/// ```
/// MultiLineTextView(text: $description)
/// ```
struct MultiLineTextView: View {
    @Binding var text: String

    let label: String
    let height: CGFloat
    let placeHolder: String
    
    init(text: Binding<String>,
         label: String = "Description:",
         height: CGFloat = 200,
         placeHolder: String = "Enter your text here..."
         ) {
        self._text = text
        
        self.label = label
        self.height = height
        self.placeHolder = placeHolder
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Enter your text here...")
                        .foregroundColor(.gray)
                }
                
                TextEditor(text: $text)
                    .padding(4)
                    .frame(height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
        }
    }
}

/// A configurable view to display and obtain user's rating.
struct RatingView: View {
    @Binding var rating: Int
    var maxRating: Int
    var starSize: CGFloat
    var color: Color
    
    init(rating: Binding<Int>,
         maxRating: Int = 7,
         starSize: CGFloat = 20,
         color: Color = .purple
         ) {
        self._rating = rating
        self.maxRating = maxRating
        self.starSize = starSize
        self.color = color
    }
    
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(star <= rating ? color : .gray)
                    .onTapGesture {
                        rating = star
                    }
            }
        }
    }
}

#Preview {
    AnimalDetailView(animal: Animal(name: "Panda", emoji: "🐼"), animalListViewModel: AnimalListViewModel())
}

