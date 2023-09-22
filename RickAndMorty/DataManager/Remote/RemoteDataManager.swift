//
//  RemoteDataManager.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

final class RemoteDataManager: RemoteDataManagerProtocol {
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

//struct Iteractor {
//    var getCharacters: () async -> [Character]
//    var getCharacter: () async -> Character
//
//    static func iteractor() -> Iteractor {
//        return Iteractor {
//            try? await Task.sleep(until: .now + .seconds(2), clock: .continuous)
//            return [
//                Character(id: 1, name: "Mohammed", species: "Volador"),
//                Character(id: 2, name: "Margarita", species: "Flor"),
//                Character(id: 3, name: "Vallisoletano", species: "People"),
//                Character(id: 4, name: "Camello", species: "Animal"),
//                Character(id: 5, name: "Robot", species: "Techno")
//            ]
//        } getCharacter: {
//            try? await Task.sleep(until: .now + .seconds(2), clock: .continuous)
//            return Character(id: 4, name: "Barbarie", species: "Keent")
//        }
//
//    }
//
//    func allCharacters() async -> [Character] {
//        try? await Task.sleep(until: .now + .seconds(2), clock: .continuous)
//        return [
//            Character(id: 1, name: "Mohammed", species: "Volador"),
//            Character(id: 2, name: "Margarita", species: "Flor"),
//            Character(id: 3, name: "Vallisoletano", species: "People"),
//            Character(id: 4, name: "Camello", species: "Animal"),
//            Character(id: 5, name: "Robot", species: "Techno")
//        ]
//    }
//
//    func oneCharacter(id: Int) async -> Character {
//        try? await Task.sleep(until: .now + .seconds(2), clock: .continuous)
//        return Character(id: 4, name: "Barbarie", species: "Keent")
//    }
//}

