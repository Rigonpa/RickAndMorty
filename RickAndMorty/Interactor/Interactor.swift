//
//  Interactor.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 23/9/23.
//

import Foundation

struct Interactor: InteractorProtocol {
    let remoteApi: RemoteApiProtocol
    let cache: CacheProtocol

    init(remoteApi: RemoteApiProtocol, cache: CacheProtocol) {
        self.remoteApi = remoteApi
        self.cache = cache
    }
}

// MARK: - Characters

extension Interactor {
    
    func getCharactersWith(status: Status) async throws -> CharacterResponse? {
        try await remoteApi.getCharactersWith(status: status)
    }
    
    func getCharactersOfNext(page: Int, with status: Status) async throws -> CharacterResponse? {
        try await remoteApi.getCharactersOfNext(page: page, with: status)
    }
}

// MARK: - Episodes

extension Interactor {
    
    func getAllEpisodes() throws -> [Episode] {
        try cache.getEpisodes()
    }
    
    func persistAllEpisodes() async throws -> Bool {
        
        // 1. Check if episodes are already locally persisted
        let localEpisodes = try cache.getEpisodes()
        guard localEpisodes.count == 0 else { return true }
        
        // 2. Get remote episodes
        let remoteEpisodes = try await getRemoteEpisodes()
        
        // 3. Save them locally
        let done = try cache.persistEpisodes(episodes: remoteEpisodes)
        
        return done
    }
    
    fileprivate func getRemoteEpisodes() async throws -> [Episode] {
        
        var totalEpisodes: [Episode] = []
        
        guard let response = try await remoteApi.getEpisodesFirstPage() else { return []}
        
        totalEpisodes.append(contentsOf: response.results)
        let totalPages = response.info.pages ?? 0
        var currentPage = 2
        
        for _ in currentPage...totalPages {
            let moreEpisodes = try await remoteApi.getEpisodesNext(page: currentPage)
            totalEpisodes.append(contentsOf: moreEpisodes)
            currentPage += 1
        }
        
        return totalEpisodes
    }
    
}

