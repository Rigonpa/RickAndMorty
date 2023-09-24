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
    var characterImage: String
    
    var color = Color.random()
    
    var body: some View {
        VStack {
            if let character = viewModel.character {
                ScrollView {
                    CharacterInfoView(
                        character: character,
                        image: characterImage,
                        color: color
                    )
                    if let episodes = character.episodes, episodes.count != 0 {
                        CharacterEpisodesView(
                            episodes: episodes,
                            color: color
                        )
                    }
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
