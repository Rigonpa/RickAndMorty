//
//  RemoteDataManagerProtocol.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

protocol RemoteDataManagerProtocol: AnyObject {
    func getCharacters() async throws -> [Character]
    func getCharacter(id: Int) async throws -> Character?
}
