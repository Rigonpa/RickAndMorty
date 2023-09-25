//
//  EpisodeResponse.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import Foundation

struct EpisodeResponse: Codable {
    let info: Info
    let results: [Episode]
}
