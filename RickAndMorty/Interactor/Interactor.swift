//
//  Interactor.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 23/9/23.
//

import Foundation

protocol CharacterInteractorProtocol {
    func getCharacters() async throws -> [Character]
    func getCharacter(id: Int) async throws -> Character?
}

struct CharacterInteractor: CharacterInteractorProtocol {
    
    func getCharacters() async throws -> [Character] {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/[1,2,3,4,5]") else { return [] }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let characters = try JSONDecoder().decode([Character].self, from: data)
        return characters
    }
    
    func getCharacter(id: Int) async throws -> Character? {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/\(id)") else { return nil }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let character = try JSONDecoder().decode(Character.self, from: data)
        return character
    }
}

