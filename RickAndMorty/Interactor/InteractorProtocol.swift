//
//  InteractorProtocol.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 24/9/23.
//

import Foundation

protocol InteractorProtocol {
    func getCharacters() async throws -> [Character]
    func getCharacter(id: Int) async throws -> Character?
    func getMultipleEpisodes(array: String) async throws -> [Episode]
}
