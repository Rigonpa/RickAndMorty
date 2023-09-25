//
//  CacheProtocol.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 25/9/23.
//

import Foundation

protocol CacheProtocol {
    
    // MARK: - Characters
    
    // ...
    
    // MARK: - Episodes
    
    func persistEpisodes(episodes: [Episode]) throws -> Bool
    func getEpisodes() throws -> [Episode]
}
