//
//  InteractorProtocol.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import Foundation

protocol InteractorProtocol {
    func getCharactersWith(status: Status) async throws -> CharacterResponse?
    func getCharacter(id: Int) async throws -> Character?
    func getMultipleEpisodes(array: String) async throws -> [Episode]
    func getCharactersOfNext(page: Int, with status: Status) async throws -> CharacterResponse?
}
