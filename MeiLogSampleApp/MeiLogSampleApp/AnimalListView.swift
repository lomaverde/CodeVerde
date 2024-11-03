//
//  SearchItemView.swift
//  MeiLogSampleApp
//
//  Created by Mei Yu on 11/2/24.
//

import SwiftUI

struct AnimalListView: View {
    @StateObject private var viewModel = AnimalListViewModel()
    private var logs: AnalaticsLogs { viewModel.logs }
    var searchBarWidth: CGFloat { UIScreen.main.bounds.width * 0.80 }
    
    var body: some View {
        NavigationView {
            List(viewModel.filteredAnimals) { animal in
                NavigationLink(destination: AnimalDetailView(animal: animal)) {
                    HStack {
                        Text(animal.emoji)
                            .font(.largeTitle)
                        Text(animal.name)
                            .font(.headline)
                            .padding(.leading, 10)
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Animals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        TextField("Search...", text: $viewModel.searchText)
                            .frame(width: searchBarWidth, height: 36)
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                HStack {
                                    Spacer()
                                    if !viewModel.searchText.isEmpty {
                                        Button(action: {
                                            viewModel.searchText = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                            )
                    }
                }
            }
            .onAppear {
                print("AnimalListView appeared")
                logs.viewInteractionEvent.start() // Start interaction logging
            }
            .onDisappear {
                print("AnimalListView disappeared")
                logs.viewInteractionEvent.log() // Log end of interaction
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// Detail View for Each Animal
struct AnimalDetailView: View {
    let animal: Animal
    
    var body: some View {
        VStack {
            Text(animal.emoji)
                .font(.system(size: 100))
                .padding()
            
            Text(animal.name)
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationTitle(animal.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("AnimalDetailView appeared")
        }
        .onDisappear {
            print("AnimalDetailView disappeared")
        }
    }
}

#Preview {
    AnimalListView()
}
