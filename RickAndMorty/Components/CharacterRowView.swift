//
//  CharacterRowView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 25/9/23.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character
    var body: some View {
        HStack {
            CacheAsyncImage(urlString: character.image) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 72)
                    .background(Color.gray)
                    .cornerRadius(8)
            }
            
            NavigationLink(destination: DetailView(character: character)) {
                Text(character.name)
            }
        }
    }
}
