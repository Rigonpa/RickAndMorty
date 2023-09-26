//
//  ExampleDataServiceTests.swift
//  RickAndMortyTests
//
//  Created by Ricardo González Pacheco on 26/9/23.
//

import XCTest
@testable import RickAndMorty
import Combine

// Naming structure: text_UnitOfWork_StateUnderTest_ExpectedBehaviour
// Naming structure: text_[struct or class]_[variable or function]_[expected result]
// Testing structure: given, when, then

final class ExampleDataServiceTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }
    
    func test_NewMockDataService_init_setValuesCorrectly() {
        // Given
        let items: [String]? = nil
        let items2: [String]? = []
        let items3: [String]? = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        
        // When
        let dataService = ExampleDataService(items: items)
        let dataService2 = ExampleDataService(items: items2)
        let dataService3 = ExampleDataService(items: items3)
        
        // Then
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
    }
    
    func test_NewMockDataService_downloadItemsWithEscaping_doesReturnValues() {
        // Given
        let dataService = ExampleDataService(items: nil)
        
        // When
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemsWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
        
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesReturnValues() {
        // Given
        let dataService = ExampleDataService(items: nil)
        
        // When
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
        
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesFail() {
        // Given
        let dataService = ExampleDataService(items: [])
        
        // When
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation.fulfill()
                    
                    let urlError = error as? URLError
                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                }
            } receiveValue: { returnedItems in
                items = returnedItems
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
        
    }

}
