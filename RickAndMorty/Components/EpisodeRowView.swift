//
//  EpisodeRowView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import SwiftUI

struct EpisodeRowView: View {
    
    var episode: Episode
    var color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.white)
                            .shadow(radius: 5)
            
            HStack(spacing: 20) {
                Image(systemName: "tv")
                    .font(.system(size: 30))
                    .frame(width: 60, height: 60)
                    .foregroundColor(color)
                    .offset(x: 10)
                
                VStack(alignment: .leading){
                    Text(episode.name)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .offset(x: 0)
                    
                    Text(episode.episode)
                        .italic()
                        .font(.footnote)
                    
                    Text(episode.airDate)
                        .font(.footnote)
                        .foregroundColor(Color(.darkGray))
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
            
        }
        .frame(height: 100)
    }
}
