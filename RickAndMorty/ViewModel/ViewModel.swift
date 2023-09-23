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
    
    private var interactor: CharacterInteractorProtocol = CharacterInteractor()
    
    init(characters: [Character] = [], character: Character? = nil) {
        self.characters = characters
        self.character = character
    }
    
    func loadCharacters() {
        Task { @MainActor in
            do {
                let characters = try await interactor.getCharacters()
                self.characters = characters
            }
            catch {}
        }
    }
    
    func loadCharacter(id: Int) {
        Task { @MainActor in
            do {
                guard let character = try await interactor.getCharacter(id: id) else { return }
                self.character = character
            }
            catch {}
        }
    }
    
    func resetDetail(newId: Int) {
        if newId != self.character?.id {
            self.character = nil
        }
    }
}
