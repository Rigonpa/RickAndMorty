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
    
    var interactor: InteractorProtocol
    init(interactor: InteractorProtocol, characters: [Character] = [], character: Character? = nil) {
        self.interactor = interactor
        self.characters = characters
        self.character = character
    }
}

// MARK: - Remote data methods

extension ViewModel {
    
    func getInitialData() {
        Task { @MainActor in
            do {
                let _ = try await interactor.persistAllEpisodes()
                
                loadCharactersWith(status: .alive)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    func loadCharactersWith(status: Status) {
        Task { @MainActor in
            do {
                guard let response = try await interactor.getCharactersWith(status: status) else { return }
                
                manageCharacters(response: response)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    fileprivate func manageCharacters(response: CharacterResponse) {
        
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
    
    func loadEpisodes(of character: Character) {
        var characterWithEpisodes = character
        do {
            
            let allEpisodes = try interactor.getAllEpisodes()
            
            let episodes = getSpecific(
                urls: character.episode ?? [],
                allEpisodes: allEpisodes
            )
            
            characterWithEpisodes.episodes = episodes
            self.character = characterWithEpisodes
        }
        catch let error {
            print(error)
        }
    }
}

// MARK: - Logic methods

extension ViewModel {
    
    func appIsNotReady() -> Bool {
        appIsReady == false
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
    
    fileprivate func getSpecific(urls: [String], allEpisodes: [Episode]) -> [Episode] {
        
        let episodesIds = urls.map { $0.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "") }
        
        let specificEpisodes = allEpisodes.filter { episodesIds.contains("\($0.id)") }
        
        return specificEpisodes
    }
    
    func hasReached(lastVisible characterId: Int) {
        let lastArrayCharacterId = characters.last?.id ?? 0
        if characterId == lastArrayCharacterId {
            guard totalPages > currentPage else { return }
            loadCharactersOfNextPage()
        }
    }
}
