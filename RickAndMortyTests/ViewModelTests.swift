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
    - func getCharactersWith(status)
    - func manageCharactersResponse
 */


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

class InteractorGood: InteractorProtocol {
    func getCharactersOfNext(page: Int, with status: RickAndMorty.Status) async throws -> RickAndMorty.CharacterResponse? { return nil }
    
    func persistAllEpisodes() async throws -> Bool {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        return true
    }
    
    func getAllEpisodes() throws -> [RickAndMorty.Episode] { return [] }
    
}

enum ErrorCustomTests: LocalizedError {
    case episodesNotPersisted
    case errorRetrievingCharacters
}

class InteractorBad: InteractorProtocol {
    func getCharactersOfNext(page: Int, with status: RickAndMorty.Status) async throws -> RickAndMorty.CharacterResponse? { return nil }
    
    func persistAllEpisodes() async throws -> Bool {
        try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
        throw ErrorCustomTests.episodesNotPersisted
    }
    
    func getAllEpisodes() throws -> [RickAndMorty.Episode] { return [] }
    
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

// MARK: - func getCharactersWith(status)

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


