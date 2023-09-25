//
//  RemoteApiProtocol.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 25/9/23.
//

import Foundation

protocol RemoteApiProtocol {
    
    // MARK: - Characters
    
    func getCharactersWith(status: Status) async throws -> CharacterResponse?
    func getCharactersOfNext(page: Int, with status: Status) async throws -> CharacterResponse?
    
    // MARK: - Episodes
    
    func getEpisodesFirstPage() async throws -> EpisodeResponse?
    func getEpisodesNext(page: Int) async throws -> [Episode]
}
