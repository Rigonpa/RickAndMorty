//
//  Interactor.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 23/9/23.
//

import Foundation

let apiURL = "https://rickandmortyapi.com/api"

struct Interactor: InteractorProtocol {
    var baseURL: URL {
        guard let baseURL = URL(string: apiURL) else {
            fatalError("URL not valid")
        }
        return baseURL
    }
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func getCharacters() async throws -> [Character] {
        guard let url = URL(string: "\(baseURL)/character/?status=alive") else { return [] }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
        return response.results
    }
    
    func getCharacter(id: Int) async throws -> Character? {
        guard let url = URL(string: "\(baseURL)/character/\(id)") else { return nil }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let character = try JSONDecoder().decode(Character.self, from: data)
        return character
    }
    
    func getMultipleEpisodes(array: String) async throws -> [Episode] {
        guard let url = URL(string: "\(baseURL)/episode/\(array)") else { return [] }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let episodes = try JSONDecoder().decode([Episode].self, from: data)
        return episodes
    }
}

