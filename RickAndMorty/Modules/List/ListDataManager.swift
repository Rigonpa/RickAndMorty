//
//  ListDataManager.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

protocol ListDataManager {
    func getCharacters() async throws -> [Character]
}
