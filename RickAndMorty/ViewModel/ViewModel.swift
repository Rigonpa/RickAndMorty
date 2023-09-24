//
//  ListViewModel.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

final class ViewModel: ObservableObject {
    
    @Published private(set) var characters: [Character]
    @Published private(set) var character: Character?
    
    private var interactor: InteractorProtocol = Interactor()
    
    init(characters: [Character] = [], character: Character? = nil) {
        self.characters = characters
        self.character = character
    }
    
    func loadCharacters() {
        Task { @MainActor in
            do {
                let characters = try await interactor.getCharacters()
                let charactersNotDuplicated = characters.reduce([]) { partialResult, character in
                    var charactersIn = partialResult as? [Character] ?? []
                    let names = charactersIn.map { $0.name }
                    if names.contains(character.name) == false {
                        charactersIn.append(character)
                    }
                    
                    return charactersIn
                } as? [Character] ?? []
                self.characters = charactersNotDuplicated
            }
            catch let error {
                print(error)
            }
        }
    }
    
    func resetDetail(newId: Int) {
        if newId != self.character?.id {
            self.character = nil
        }
    }
    
    func loadCharacter(id: Int) {
        Task { @MainActor in
            do {
                guard var currentCharacter = try await interactor.getCharacter(id: id) else { return }
                let array = getEpisodesArray(episode: currentCharacter.episode ?? [])
                let episodes = try await interactor.getMultipleEpisodes(array: array)
                currentCharacter.episodes = episodes
                self.character = currentCharacter
            }
            catch {}
        }
    }
    
    fileprivate func getEpisodesArray(episode: [String]) -> String {
        
        let v1 = episode.map { $0.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "") }
        let v2 = v1.reduce("") { partialResult, value in
            partialResult == "" ? value : partialResult + "," + value
        }
        let v3 = "[" + v2 + "]"
        
        return v3
    }
}
