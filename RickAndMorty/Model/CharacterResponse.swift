//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import Foundation

struct CharacterResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}
