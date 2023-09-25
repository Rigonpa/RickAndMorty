//
//  Episode.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import Foundation

struct Episode: Codable, Hashable {
    let id: Int
    let name: String
    let episode: String
    let airDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode
        case airDate = "air_date"
    }
}
