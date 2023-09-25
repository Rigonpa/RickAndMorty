//
//  RickAndMortyApi.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 25/9/23.
//

import Foundation

let apiURL = "https://rickandmortyapi.com/api"

class RickAndMortyApi: RemoteApiProtocol {
    var baseURL: URL {
        guard let baseURL = URL(string: apiURL) else {
            fatalError("URL not valid")
        }
        return baseURL
    }
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
}

// MARK: - Characters

extension RickAndMortyApi {
    
    func getCharactersWith(status: Status) async throws -> CharacterResponse? {
        guard let url = URL(string: "\(baseURL)/character/?status=\(status.rawValue)") else { return nil }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
        return response
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

extension RickAndMortyApi {
    
    func getEpisodesFirstPage() async throws -> EpisodeResponse? {
        guard let url = URL(string: "\(baseURL)/episode") else { return nil }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(EpisodeResponse.self, from: data)
        return response
    }
    
    func getEpisodesNext(page: Int) async throws -> [Episode] {
        guard let url = URL(string: "\(baseURL)/episode?page=\(page)") else { return [] }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(EpisodeResponse.self, from: data)
        return response.results
    }
}
