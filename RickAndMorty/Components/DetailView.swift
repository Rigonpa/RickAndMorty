//
//  DetailView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 23/9/23.
//

import SwiftUI
import CoreData

struct DetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var characterId: Int
    var characterName: String
    
    var body: some View {
        VStack {
            if let character = viewModel.character {
                VStack {
                    RemoteImage(urlString: character.image)
                    Text(character.name)
                    Text(character.species)
                    Text("\(character.id)")
                }
                .navigationBarTitleDisplayMode(.inline)
            } else {
                loading()
            }
        }
        .onAppear {
            viewModel.resetDetail(newId: characterId)
            viewModel.loadCharacter(id: characterId)
        }.navigationTitle(characterName)
    }
    
    func loading() -> some View {
        ProgressView()
    }
}
