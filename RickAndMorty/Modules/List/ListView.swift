//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    @ObservedObject var viewModel: ListViewModel

    var body: some View {
        NavigationView {
            if case let .loaded(loadedState) = viewModel.state  {
                showList(characters: loadedState.characters)
            } else {
                loading()
            }
        }
        .onAppear {
            viewModel.send(event: .viewAppeared)
        }
    }
    
    func loading() -> some View {
        ProgressView()
    }
    
    func showList(characters: [Character]) -> some View {
        List {
            ForEach(characters) { character in
                HStack {
                    RemoteImage(urlString: character.image)
                    Text(character.name)
                        .bold()
                        .onTapGesture {
                            viewModel.send(event: .characterTapped(character))
                        }
                    
                }
            }
        }
        .navigationTitle("Rick And Morty")
        .listRowSeparator(.hidden)
    }
}
