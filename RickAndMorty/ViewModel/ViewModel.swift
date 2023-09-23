//
//  ListViewModel.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

final class ViewModel: ObservableObject {
    
    enum State {
        case loading
        case loaded(LoadedState)
    }
    
    struct LoadedState {
        let characters: [Character]
    }
    
    @Published private(set) var state: State
    
    private var interactor: CharacterInteractorProtocol
    
    init(state: State = .loading, interactor: CharacterInteractorProtocol) {
        self.state = state
        self.interactor = interactor
    }
    
    func loadCharacters() {
        Task { @MainActor in
            do {
                let characters = try await interactor.getCharacters()
                state = .loaded(LoadedState(characters: characters))
            }
            catch {}
        }
    }
}
