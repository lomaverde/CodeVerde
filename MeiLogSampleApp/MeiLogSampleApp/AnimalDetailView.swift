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
    
    @State private var isEmojiAnimated = false
    @State private var isTapped = false
        
    init(animal: Animal,
         animalListViewModel: AnimalListViewModel) {
        self._animal = State(initialValue: animal)
        self.animalListViewModel = animalListViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(animal.emoji)
                .font(.system(size: 100))
                .scaleEffect(isEmojiAnimated ? 1.0 : 0.5) // Scale animation
                .opacity(isEmojiAnimated ? 1 : 0.3)     // Fade-in effect
                .animation(.easeInOut(duration: 0.9), value: isEmojiAnimated)
                .offset(x: isTapped ? 100 : 0) // Moves the text to the right
                .animation(.easeInOut(duration: 0.5), value: isTapped)
                .onTapGesture {
                        isTapped.toggle()
                 }
                .onAppear {
                    isEmojiAnimated.toggle()
                }
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
    var itemSize: CGFloat
    var color: Color
    
    let animationDuration: Double = 0.2
    
    init(rating: Binding<Int>,
         maxRating: Int = 7,
         itemSize: CGFloat = 20,
         color: Color = .purple
         ) {
        self._rating = rating
        self.maxRating = maxRating
        self.itemSize = itemSize
        self.color = color
    }
    
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { item in
                Image(systemName: item <= rating ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: itemSize, height: itemSize)
                    .foregroundColor(item <= rating ? color : .gray)
                    .rotationEffect(item == rating ? .degrees(360) : .degrees(0)) // Rotation effect
                    .scaleEffect(item == rating ? 1.4 : 1.0) // Scale effect
                    .opacity(item <= rating ? 1.0 : 0.6) // Dim the unselected items
                    .animation(.easeInOut(duration: animationDuration), value: rating)
                    .onTapGesture {
                        withAnimation {
                            rating = item
                        }
                    }
            }
        }
    }
}

#Preview {
    AnimalDetailView(animal: Animal(name: "Panda", emoji: "🐼"), animalListViewModel: AnimalListViewModel())
}

