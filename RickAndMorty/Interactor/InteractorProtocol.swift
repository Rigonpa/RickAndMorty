//
//  InteractorProtocol.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import Foundation

protocol InteractorProtocol {
    
    // MARK: - Characters
    
    func getCharactersWith(status: Status) async throws -> CharacterResponse?
    func getCharactersOfNext(page: Int, with status: Status) async throws -> CharacterResponse?
    
    // MARK: - Episodes
    
    func persistAllEpisodes() async throws -> Bool
    func getAllEpisodes() throws -> [Episode]
}
