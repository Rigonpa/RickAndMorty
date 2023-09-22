//
//  ListViewModel.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

final class ListViewModel: ObservableObject {
    
    enum Event {
        case viewAppeared
        case characterTapped(Character)
    }
    
    enum State {
        case loading
        case loaded(LoadedState)
    }
    
    struct LoadedState {
        let characters: [Character]
    }
    
    @Published private(set) var state: State
    
    private var dataManager: ListDataManager
    
    init(state: State = .loading, dataManager: ListDataManager) {
        self.state = state
        self.dataManager = dataManager
    }
    
    func send(event: Event) {
        switch event {
        case .viewAppeared:
            loadCharacters()
        case .characterTapped(let chara):
            characterTapped(chara: chara)
        }
    }
    
    func loadCharacters() {
        Task { @MainActor in
            do {
                let characters = try await dataManager.getCharacters()
                state = .loaded(LoadedState(characters: characters))
            }
            catch {}
        }
    }
    
    func characterTapped(chara: Character) {
        
        // Go to detail module
    }
}
