//
//  ListViewModel.swift
//  RickAndMorty
//
//  Created by Ricardo González Pacheco on 22/9/23.
//

import Foundation

final class ViewModel: ObservableObject {
    
    var appIsReady: Bool = false
    
    @Published private(set) var characters: [Character]
    @Published private(set) var character: Character?
    
    @Published var currentStatus: Status = .alive
    let statusValues: [Status] = [.alive, .dead, .unknown]
    
    @Published var fetchingNextPage: Bool = false
    
    var currentPage: Int = 1
    var totalPages: Int = 0
    
    private var interactor: InteractorProtocol = Interactor()
    
    init(characters: [Character] = [], character: Character? = nil) {
        self.characters = characters
        self.character = character
    }
}
// MARK: - Remote data methods

extension ViewModel {
    
    func loadCharactersWith(status: Status) {
        Task { @MainActor in
            do {
                guard let response = try await interactor.getCharactersWith(status: status) else { return }
                totalPages = response.info.count ?? 0
                let charactersNotDuplicated = removeDuplicates(characters: response.results)
                if !appIsReady {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                        self?.appIsReady = true
                        self?.characters = charactersNotDuplicated
                    }
                } else {
                    self.characters = charactersNotDuplicated
                }
            }
            catch let error {
                print(error)
            }
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
            catch let error {
                print(error)
            }
        }
    }
    
    func loadCharactersOfNextPage() {
        Task { @MainActor in
            do {
                fetchingNextPage = true
                currentPage += 1
                guard let response = try await interactor.getCharactersOfNext(page: currentPage, with: currentStatus) else { return }
                let charactersNotDuplicated = removeDuplicates(characters: response.results)
                self.characters += charactersNotDuplicated
                fetchingNextPage = false
            }
            catch let error {
                print(error)
            }
        }
    }
}

// MARK: - Logic methods

extension ViewModel {
    
    func appIsNotReady() -> Bool {
        appIsReady == false
    }
    
    func resetDetail(newId: Int) {
        if newId != self.character?.id {
            self.character = nil
        }
    }
    
    fileprivate func removeDuplicates(characters: [Character]) -> [Character] {
        return characters.reduce([]) { partialResult, character in
            var charactersIn = partialResult as? [Character] ?? []
            let names = charactersIn.map { $0.name }
            if names.contains(character.name) == false {
                charactersIn.append(character)
            }
            
            return charactersIn
        } as? [Character] ?? []
    }
    
    fileprivate func getEpisodesArray(episode: [String]) -> String {
        
        let v1 = episode.map { $0.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "") }
        let v2 = v1.reduce("") { partialResult, value in
            partialResult == "" ? value : partialResult + "," + value
        }
        let v3 = "[" + v2 + "]"
        
        return v3
    }
    
    func hasReached(lastVisible characterId: Int) {
        let lastArrayCharacterId = characters.last?.id ?? 0
        if characterId == lastArrayCharacterId {
            guard totalPages > currentPage else { return }
            loadCharactersOfNextPage()
        }
    }
}
