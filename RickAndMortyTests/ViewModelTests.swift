//
//  ViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Ricardo González Pacheco on 26/9/23.
//

import XCTest
@testable import RickAndMorty

/*
 Naming structure: test_unitOfWork_systemUnderTest_expectedBehaviour
 Testing structure: Given, When, Then
 */

/*
 Testing strategy: Following cronological flow of data through the app
    - init
    - func getInitialData
    - func getCharactersWithStatus
    - func manageCharactersResponse
    - func hasReachedLastVisibleCharacter
    - func loadCharactersOfNextPage
    - func manageCharactersOfNextResponse
    - func loadEpisodesOfCharacter
    - func manageEpisodesOfCharacter
 */


class InteractorGood: InteractorProtocol {}
class InteractorBad: InteractorProtocol {}

final class ViewModelTests: XCTestCase {
    
    var remoteApi: RemoteApiProtocol?
    var cache: CacheProtocol?
    var interactor: InteractorProtocol?
    var viewModel: ViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        remoteApi = RickAndMortyApi()
        cache = CoreDataManager()
        guard let remoteApi = remoteApi, let cache = cache else {
            XCTFail()
            return
        }
        let interactor = Interactor(remoteApi: remoteApi, cache: cache)
        self.interactor = interactor
        viewModel = ViewModel(interactor: interactor)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

// MARK: - init

extension ViewModelTests {
    
    func test_ViewModel_init_shouldReceiveInteractorNotNil() {
        // Given
        guard let interactor = interactor else {
            XCTFail()
            return
        }
        
        // When
        let vm = ViewModel(interactor: interactor)
        
        // Then
        XCTAssertNotNil(vm.interactor)
    }
    
    func test_ViewModel_init_shouldSetCharactersArrayEmpty() {
        // Given
        guard let interactor = interactor else {
            XCTFail()
            return
        }
        
        // When
        let vm = ViewModel(interactor: interactor)
        
        // Then
        XCTAssertNotNil(vm.characters)
        XCTAssertEqual(vm.characters.count, 0)
    }
    
    func test_ViewModel_init_shouldSetCharacterVarNil() {
        // Given
        guard let interactor = interactor else {
            XCTFail()
            return
        }
        
        // When
        let vm = ViewModel(interactor: interactor)
        
        // Then
        XCTAssertNil(vm.character)
    }

}

// MARK: - func getInitialData

extension ViewModelTests {
    
    func test_ViewModel_appIsReady_shouldBeFalseAtBeginning() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        
        // Then
        XCTAssertFalse(viewModel.appIsReady)
    }
    
    func test_ViewModel_appIsNotReady_shouldReturnOppositeValueToVariable() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        let appIsNotReady = viewModel.appIsNotReady() // func
        let appIsReady = viewModel.appIsReady // var
        
        // Then
        XCTAssertNotEqual(appIsNotReady, appIsReady)
    }
}

extension InteractorGood {
    func persistAllEpisodes() async throws -> Bool {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        return true
    }
}

enum ErrorCustomTests: LocalizedError {
    case episodesNotPersisted
    case errorRetrievingCharacters
    case errorRetrievingNextCharacters
    case errorRetrievingEpisodes
}

extension InteractorBad {
    func persistAllEpisodes() async throws -> Bool {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        throw ErrorCustomTests.episodesNotPersisted
    }
}

extension ViewModelTests {
    
    func test_ViewModel_getInitialData_shouldReturnsTrueWhenIsOk() async throws {
        // Given
        let interactorGood: InteractorProtocol = InteractorGood()
        
        // When
        let isOk = try await interactorGood.persistAllEpisodes()
        
        // Then
        XCTAssertTrue(isOk)
        
    }
    
    func test_ViewModel_getInitialData_shouldThrowErrorWhenConflicts() async throws {
        // Given
        let interactorBad: InteractorProtocol = InteractorBad()
        
        // When
        
        // Then
        do {
            let _ = try await interactorBad.persistAllEpisodes()
        } catch let error {
            let returnedError = error as? ErrorCustomTests
            XCTAssertEqual(returnedError, ErrorCustomTests.episodesNotPersisted)
        }
    }
}

// MARK: - func getCharactersWithStatus

extension ViewModelTests {
    
    func test_ViewModel_currentStatus_shouldBeAliveAtBeginning() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        
        // Then
        XCTAssertEqual(viewModel.currentStatus, Status.alive)
    }
    
    func test_ViewModel_statusValues_shouldContain3ValuesAtBeginning() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        
        // Then
        XCTAssertFalse(viewModel.statusValues.isEmpty)
        XCTAssertEqual(viewModel.statusValues.count, 3)
    }
    
    func test_ViewModel_statusValues_shouldContainThe3StatusCasesAtBeginning() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let statusValuesTests = [Status.alive, Status.dead, Status.unknown]
        
        // When
        
        // Then
        XCTAssertEqual(viewModel.statusValues.first, statusValuesTests.first)
        XCTAssertEqual(viewModel.statusValues[2], statusValuesTests[2])
        XCTAssertEqual(viewModel.statusValues.last, statusValuesTests.last)
        XCTAssertEqual(viewModel.statusValues, statusValuesTests)
    }
}

extension InteractorGood {
    func getCharactersWith(status: RickAndMorty.Status) async throws -> RickAndMorty.CharacterResponse? {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        let results = [
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil),
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil),
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil),
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil)
        ]
        let characterResponse = CharacterResponse(info: info, results: results)
        
        return characterResponse
    }
}

extension InteractorBad {
    func getCharactersWith(status: RickAndMorty.Status) async throws -> RickAndMorty.CharacterResponse? {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        
        throw ErrorCustomTests.errorRetrievingCharacters
    }
}

extension ViewModelTests {
    
    func test_ViewModel_getCharactersWithStatus_shouldReturnLoadedArrayWhenIsOk() async throws {
        // Given
        let interactorGood: InteractorProtocol = InteractorGood()
        
        // When
        let response = try await interactorGood.getCharactersWith(status: .alive)
        let characters = response?.results
        
        // Then
        XCTAssertNotNil(response)
        XCTAssertNotNil(characters)
        XCTAssertFalse(characters?.isEmpty ?? true)
//        XCTAssertGreaterThan(characters?.count ?? 0, 0)
        
    }
    
    func test_ViewModel_getCharactersWithStatus_shouldThrowErrorWhenConflicts() async throws {
        // Given
        let interactorBad: InteractorProtocol = InteractorBad()
        
        // When
        
        // Then
        do {
            let _ = try await interactorBad.getCharactersWith(status: .alive)
        } catch let error {
            let returnedError = error as? ErrorCustomTests
            XCTAssertEqual(returnedError, ErrorCustomTests.errorRetrievingCharacters)
        }
    }
}

// MARK: - func hasReachedLastVisibleCharacter

class ViewModelForHasReachedTest {
    let characters = [
        Character(id: 1, name: "", species: "", image: "", status: "", episode: nil),
        Character(id: 2, name: "", species: "", image: "", status: "", episode: nil),
        Character(id: 3, name: "", species: "", image: "", status: "", episode: nil),
        Character(id: 4, name: "", species: "", image: "", status: "", episode: nil)
    ]
    
    @Published var fetchingNextPage: Bool = false
    
    var currentPage: Int = 1
    var totalPages: Int = 6
    
    func hasReached(lastVisible characterId: Int) {
        let lastArrayCharacterId = characters.last?.id ?? 0
        if characterId == lastArrayCharacterId {
            guard totalPages > currentPage else { return }
            loadCharactersOfNextPage()
        }
    }
    
    func loadCharactersOfNextPage() {
        
        fetchingNextPage = true
        currentPage += 1
        
        // ......
        
//        Task { @MainActor in
//            do {
//
//                guard let response = try await interactor.getCharactersOfNext(page: currentPage, with: currentStatus) else { return }
//
//                manageCharactersOfNext(response: response)
//            }
//            catch let error {
//                print(error)
//            }
//        }
    }
}

extension ViewModelTests {
    
    func test_ViewModel_hasReachedLastVisibleCharacter_shouldDoNothingWhenCharactersListBottomIsNotReached() {
        // Given
        let viewModel = ViewModelForHasReachedTest()
        
        let lastVisibleCharacterId = 2
        
        // When
        XCTAssertFalse(viewModel.fetchingNextPage)
        XCTAssertEqual(viewModel.characters.count, 4)
        
        viewModel.hasReached(lastVisible: lastVisibleCharacterId)
        
        // Then
        XCTAssertFalse(viewModel.fetchingNextPage)
    }
    
    func test_ViewModel_hasReachedLastVisibleCharacter_shouldFireFunctionLoadCharactersOfNextPage() {
        // Given
        let viewModel = ViewModelForHasReachedTest()
        
        let lastVisibleCharacterId = 4
        
        // When
        XCTAssertFalse(viewModel.fetchingNextPage)
        XCTAssertEqual(viewModel.characters.count, 4)
        
        viewModel.hasReached(lastVisible: lastVisibleCharacterId)
        
        // Then
        XCTAssertTrue(viewModel.fetchingNextPage)
    }
}

// MARK: - func manageCharactersResponse

extension ViewModelTests {
    
    func test_ViewModel_currentPage_shouldBe1AtBeginning() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        
        
        // Then
        XCTAssertEqual(viewModel.currentPage, 1)
    }
    
    func test_ViewModel_totalPages_shouldBe0AtBeginning() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        
        
        // Then
        XCTAssertEqual(viewModel.totalPages, 0)
    }
    
    func test_ViewModel_fetchingNextPage_shouldBeFalseAtBeginning() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        
        
        // Then
        XCTAssertFalse(viewModel.fetchingNextPage)
    }
    
    func test_ViewModel_totalPages_shouldBeUpdatedWithCharactersCall() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        let totalPagesOfCharacters = 5
        
        // When
        viewModel.totalPages = totalPagesOfCharacters
        
        
        // Then
        XCTAssertEqual(viewModel.totalPages, totalPagesOfCharacters)
    }
    
    func test_ViewModel_removeDuplicates_shouldRemoveDuplicatedValues() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let characters = [
            Character(id: 1, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 2, name: "Begoña", species: "", image: "", status: "", episode: nil),
            Character(id: 3, name: "Fermín", species: "", image: "", status: "", episode: nil),
            Character(id: 1, name: "Pedro", species: "", image: "", status: "", episode: nil)
        ]
        
        // When
        let charactersNotDuplicated = viewModel.removeDuplicates(characters: characters)
        let pedroRemainsInTheArray = charactersNotDuplicated.filter { $0.name == "Pedro" }
        let begoñaRemainsInTheArray = charactersNotDuplicated.filter { $0.name == "Begoña" }
        let ferminRemainsInTheArray = charactersNotDuplicated.filter { $0.name == "Fermín" }
        
        
        // Then
        XCTAssertEqual(charactersNotDuplicated.count, 3)
        XCTAssertEqual(pedroRemainsInTheArray.count, 1)
        XCTAssertEqual(begoñaRemainsInTheArray.count, 1)
        XCTAssertEqual(ferminRemainsInTheArray.count, 1)
        
        
    }
    
    func test_ViewModel_manageCharacters_shouldFillLocalCharactersArray() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        let results = [
            Character(id: 1, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 2, name: "Begoña", species: "", image: "", status: "", episode: nil),
            Character(id: 3, name: "Fermin", species: "", image: "", status: "", episode: nil),
            Character(id: 4, name: "Marta", species: "", image: "", status: "", episode: nil)
        ]
        let characterResponse = CharacterResponse(info: info, results: results)
        
        // When
        viewModel.appIsReady = true
        
        XCTAssertEqual(viewModel.characters.count, 0)
        viewModel.manageCharacters(response: characterResponse)
        
        // Then
        XCTAssertEqual(viewModel.characters.count, results.count)
    }
    
    func test_ViewModel_manageCharacters_shouldFillLocalCharactersArrayWithoutDuplication() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        let results = [
            Character(id: 1, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 2, name: "Pedro", species: "", image: "", status: "", episode: nil), // duplicated
            Character(id: 3, name: "Pedro", species: "", image: "", status: "", episode: nil), // duplicated
            Character(id: 4, name: "Marta", species: "", image: "", status: "", episode: nil)
        ]
        let characterResponse = CharacterResponse(info: info, results: results)
        
        // When
        viewModel.appIsReady = true
        
        XCTAssertEqual(viewModel.characters.count, 0)
        viewModel.manageCharacters(response: characterResponse)
        
        // Then
        XCTAssertEqual(viewModel.characters.count, 2)
    }
    
    func test_ViewModel_manageCharacters_shouldFillLocalCharactersArray_stress() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        
        var results: [Character] = []
        for i in 0..<Int.random(in: 0..<20) {
            results.append(Character(id: i, name: "", species: "", image: "", status: "", episode: nil))
        }
        let characterResponse = CharacterResponse(info: info, results: results)
        
        // When
        viewModel.appIsReady = true
        
        XCTAssertEqual(viewModel.characters.count, 0)
        viewModel.manageCharacters(response: characterResponse)
        
        // Then
        XCTAssertNotEqual(viewModel.characters.count, results.count)
    }
}

// MARK: - func loadCharactersOfNextPage

extension ViewModelTests {
    
    func test_ViewModel_loadCharactersOfNextPage_shouldIncreaseTheValueOfVarCurrentPage() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        viewModel.loadCharactersOfNextPage()
        
        // Then
        XCTAssertEqual(viewModel.currentPage, 2)
    }
    
    func test_ViewModel_loadCharactersOfNextPage_shouldSetTrueForVarFetchingNextPage() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        viewModel.loadCharactersOfNextPage()
        
        // Then
        XCTAssertTrue(viewModel.fetchingNextPage)
    }
}

extension InteractorGood {
    func getCharactersOfNext(page: Int, with status: RickAndMorty.Status) async throws -> RickAndMorty.CharacterResponse? {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        let results = [
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil),
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil),
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil),
            Character(id: 1, name: "", species: "", image: "", status: "", episode: nil)
        ]
        let characterResponse = CharacterResponse(info: info, results: results)
        
        return characterResponse
    }
}

extension InteractorBad {
    func getCharactersOfNext(page: Int, with status: RickAndMorty.Status) async throws -> RickAndMorty.CharacterResponse? {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        
        throw ErrorCustomTests.errorRetrievingNextCharacters
    }
}

extension ViewModelTests {
    
    func test_ViewModel_loadCharactersOfNextPage_shouldThrowErrorWhenConflicts() async throws {
        // Given
        let interactorBad: InteractorProtocol = InteractorBad()
        
        // When
        
        // Then
        do {
            let _ = try await interactorBad.getCharactersOfNext(page: 2, with: .alive)
        } catch let error {
            let returnedError = error as? ErrorCustomTests
            XCTAssertEqual(returnedError, ErrorCustomTests.errorRetrievingNextCharacters)
        }
    }
    
    func test_ViewModel_loadCharactersOfNextPage_shouldReturnLoadedArrayWhenIsOk() async throws {
        // Given
        let interactorGood: InteractorProtocol = InteractorGood()
        
        // When
        let response = try await interactorGood.getCharactersOfNext(page: 2, with: .alive)
        let characters = response?.results
        
        // Then
        XCTAssertNotNil(response)
        XCTAssertNotNil(characters)
        XCTAssertFalse(characters?.isEmpty ?? true)
        XCTAssertEqual(characters?.count, 4)
        
    }
}

// MARK: - func manageCharactersOfNextResponse

extension ViewModelTests {
    
    func test_ViewModel_manageCharactersOfNext_shouldAddContentToLocalCharactersArray() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        let results = [
            Character(id: 1, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 2, name: "Begoña", species: "", image: "", status: "", episode: nil),
            Character(id: 3, name: "Fermin", species: "", image: "", status: "", episode: nil),
            Character(id: 4, name: "Marta", species: "", image: "", status: "", episode: nil)
        ]
        let characterResponse = CharacterResponse(info: info, results: results)
        
        // When
        XCTAssertEqual(viewModel.characters.count, 0)
        
        viewModel.manageCharactersOfNext(response: characterResponse)
        
        // Then
        XCTAssertEqual(viewModel.characters.count, 4)
    }
    
    func test_ViewModel_manageCharactersOfNext_shouldAddContentToLocalCharactersArrayWithoutDuplication() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        let results = [
            Character(id: 1, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 2, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 3, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 4, name: "Marta", species: "", image: "", status: "", episode: nil)
        ]
        let characterResponse = CharacterResponse(info: info, results: results)
        
        // When
        XCTAssertEqual(viewModel.characters.count, 0)
        
        viewModel.manageCharactersOfNext(response: characterResponse)
        
        // Then
        XCTAssertEqual(viewModel.characters.count, 2)
    }
    
    func test_ViewModel_loadCharactersOfNextPage_shouldSetFalseForVarFetchingNextPage() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let info = Info(count: 120, pages: 6, next: "", prev: "")
        let results = [
            Character(id: 1, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 2, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 3, name: "Pedro", species: "", image: "", status: "", episode: nil),
            Character(id: 4, name: "Marta", species: "", image: "", status: "", episode: nil)
        ]
        let characterResponse = CharacterResponse(info: info, results: results)
        
        // When
        viewModel.manageCharacters(response: characterResponse)
        
        // Then
        XCTAssertFalse(viewModel.fetchingNextPage)
    }
}

// MARK: - func loadEpisodesOfCharacter

extension InteractorGood {
    func getAllEpisodes() throws -> [RickAndMorty.Episode] {
        
        let episodes = [
            Episode(id: 1, name: "", episode: "", airDate: ""),
            Episode(id: 1, name: "", episode: "", airDate: ""),
            Episode(id: 1, name: "", episode: "", airDate: ""),
            Episode(id: 1, name: "", episode: "", airDate: ""),
            Episode(id: 1, name: "", episode: "", airDate: "")
        ]
        
        return episodes
    }
}

extension InteractorBad {
    func getAllEpisodes() throws -> [RickAndMorty.Episode] {
        throw ErrorCustomTests.errorRetrievingEpisodes
    }
}

extension ViewModelTests {
    
    func test_ViewModel_getEpisodesOfCharacter_shouldThrowErrorWhenConflicts() throws {
        // Given
        let interactorBad: InteractorProtocol = InteractorBad()
        
        // When
        
        // Then
        do {
            let _ = try interactorBad.getAllEpisodes()
        } catch let error {
            let returnedError = error as? ErrorCustomTests
            XCTAssertEqual(returnedError, ErrorCustomTests.errorRetrievingEpisodes)
        }
    }
    
    func test_ViewModel_getEpisodesOfCharacter_shouldReturnLoadedArrayWhenIsOk() throws {
        // Given
        let interactorGood: InteractorProtocol = InteractorGood()
        
        // When
        let episodes = try interactorGood.getAllEpisodes()
        
        // Then
        XCTAssertFalse(episodes.isEmpty)
        XCTAssertEqual(episodes.count, 5)
        
    }
}

// MARK: - func manageEpisodesOfCharacter

extension ViewModelTests {
    
    func test_ViewModel_getSpecificEpisodes_shouldTransformUrlIntoEpisodes() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let urls = [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2",
            "https://rickandmortyapi.com/api/episode/3"
        ]
        
        let allEpisodes = [
            Episode(id: 1, name: "Episode 1", episode: "", airDate: ""),
            Episode(id: 2, name: "Episode 2", episode: "", airDate: ""),
            Episode(id: 3, name: "Episode 3", episode: "", airDate: ""),
            Episode(id: 4, name: "Episode 4", episode: "", airDate: ""),
            Episode(id: 5, name: "Episode 5", episode: "", airDate: ""),
            Episode(id: 6, name: "Episode 6", episode: "", airDate: "")
        ]
        
        // When
        let specificEpisodes = viewModel.getSpecific(urls: urls, allEpisodes: allEpisodes)
        let episodeOne = specificEpisodes.filter { $0.name == "Episode 1" }
        let episodeTwo = specificEpisodes.filter { $0.name == "Episode 2" }
        let episodeThree = specificEpisodes.filter { $0.name == "Episode 3" }
        
        // Then
        XCTAssertEqual(specificEpisodes.count, 3)
        XCTAssertEqual(episodeOne.count, 1)
        XCTAssertEqual(episodeTwo.count, 1)
        XCTAssertEqual(episodeThree.count, 1)
    }
    
    func test_ViewModel_manageEpisodesOfCharacter_shouldAsignValueToLocalVarCharacterContainingEpisodes() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        let urls = [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2",
            "https://rickandmortyapi.com/api/episode/3"
        ]
        
        let allEpisodes = [
            Episode(id: 1, name: "Episode 1", episode: "", airDate: ""),
            Episode(id: 2, name: "Episode 2", episode: "", airDate: ""),
            Episode(id: 3, name: "Episode 3", episode: "", airDate: ""),
            Episode(id: 4, name: "Episode 4", episode: "", airDate: ""),
            Episode(id: 5, name: "Episode 5", episode: "", airDate: ""),
            Episode(id: 6, name: "Episode 6", episode: "", airDate: ""),
        ]
        
        let character = Character(id: 3, name: "Tomás", species: "", image: "", status: "", episode: urls)
        
        // When
        XCTAssertNil(viewModel.character)
        
        viewModel.manageEpisodes(allEpisodes, of: character)
        
        // Then
        XCTAssertNotNil(viewModel.character)
        XCTAssertEqual(viewModel.character?.name, character.name)
        XCTAssertNotNil(viewModel.character?.episodes)
        XCTAssertFalse(viewModel.character?.episodes?.isEmpty ?? true)
        XCTAssertEqual(viewModel.character?.episodes?.count, urls.count)
        
    }
}


