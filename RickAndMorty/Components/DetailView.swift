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
                    Spacer(minLength: 32)
                    RemoteImage(urlString: characterImage, isList: false, color: color)
                    Spacer(minLength: 20)
                    Text(character.name)
                        .font(.title3)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                        .textCase(.uppercase)
                        .fontWeight(.bold)
                        .offset(x: -32)
                    Text(character.species)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                        .offset(x: -32)
                    Text(character.status)
                        .italic()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                        .offset(x: -32)
                    Spacer(minLength: 32)
                    
                    if let episodes = character.episodes, episodes.count != 0 {
                        Text("Episodes  📺")
                            .font(.title2)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            .offset(x: 32)
                        
                        LazyVStack {
                            ForEach(episodes, id: \.self) { episode in
                                EpisodeRowView(episode: episode, color: color)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 32)
                            }
                        }
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
