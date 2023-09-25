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
    
    var character: Character
    
    var color = Color.random()
    
    var body: some View {
        VStack {
            ScrollView {
                CharacterInfoView(
                    character: character,
                    color: color
                )
                if let characterWithEpisodes = viewModel.character {
                    if let episodes = characterWithEpisodes.episodes,
                        episodes.count != 0 {
                        CharacterEpisodesView(
                            episodes: episodes,
                            color: color
                        )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadEpisodes(of: character)
        }
        .navigationTitle(character.name)
    }
    
    func loading() -> some View {
        ProgressView()
    }
}
