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
}

// MARK: - Characters

extension Interactor {
    
    func getCharactersWith(status: Status) async throws -> CharacterResponse? {
        guard let url = URL(string: "\(baseURL)/character/?status=\(status.rawValue)") else { return nil }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
        return response
    }
    
    func getCharacter(id: Int) async throws -> Character? {
        guard let url = URL(string: "\(baseURL)/character/\(id)") else { return nil }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let character = try JSONDecoder().decode(Character.self, from: data)
        return character
    }
    
    func getCharactersOfNext(page: Int, with status: Status) async throws -> CharacterResponse? {
        guard let url = URL(string: "\(baseURL)/character/?page=\(page)&status=\(status.rawValue)") else { return nil }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
        return response
    }
}

// MARK: - Episodes

extension Interactor {
    
    func getMultipleEpisodes(array: String) async throws -> [Episode] {
        guard let url = URL(string: "\(baseURL)/episode/\(array)") else { return [] }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let episodes = try JSONDecoder().decode([Episode].self, from: data)
        return episodes
    }
}

