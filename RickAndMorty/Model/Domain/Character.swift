//
//  Character.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

struct Character: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let species: String
    let image: String
    let status: String
    let episode: [String]?
    var episodes: [Episode]?
}
