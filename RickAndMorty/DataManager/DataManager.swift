//
//  Iteractor.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

class DataManager {
    private let remoteDataManager: RemoteDataManagerProtocol
    init(remoteDataManager: RemoteDataManagerProtocol) {
        self.remoteDataManager = remoteDataManager
    }
}

extension DataManager: ListDataManager {
    func getCharacters() async throws -> [Character] {
        try await remoteDataManager.getCharacters()
    }
}

