//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            if viewModel.characters.count != 0 {
                showList(characters: viewModel.characters)
            } else {
                loading()
            }
        }
        .onAppear {
            viewModel.loadCharacters()
        }
    }
    
    func loading() -> some View {
        ProgressView()
    }
    
    func showList(characters: [Character]) -> some View {
        List {
            ForEach(characters) { character in
                HStack {
                    RemoteImage(urlString: character.image, isList: true)
                    NavigationLink(destination: DetailView(characterId: character.id, characterName: character.name, characterImage: character.image)) {
                        Text(character.name)
                    }
                }
            }
        }
        .navigationTitle("Rick And Morty")
    }
}
