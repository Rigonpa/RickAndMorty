//
//  CharacterEpisodesView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import SwiftUI

struct CharacterEpisodesView: View {
    var episodes: [Episode]
    var color: Color
    var body: some View {
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
        .offset(y: 8)
    }
}
