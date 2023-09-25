//
//  CharacterInfoView.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import SwiftUI

struct CharacterInfoView: View {
    let character: Character
    let color: Color
    var body: some View {
        Spacer(minLength: 32)
        RemoteImage(urlString: character.image, isList: false, color: color)
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
        Spacer(minLength: 38)
    }
}
