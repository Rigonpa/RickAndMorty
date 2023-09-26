//
//  ExampleViewModelTests.swift
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

final class ExampleViewModelTest: XCTestCase {
    
    var viewModel: ExampleViewModel?
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ExampleViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func test_ExampleViewModel_isPremium_shouldBeTrue() {
        // Given
        let userIsPremium: Bool = true
        
        // When
        let vm = ExampleViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_ExampleViewModel_isPremium_shouldBeFalse() {
        // Given
        let userIsPremium: Bool = false
        
        // When
        let vm = ExampleViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertFalse(vm.isPremium)
    }
    
    func test_ExampleViewModel_isPremium_shouldBeInjectedValue() {
        // Given
        let userIsPremium: Bool = Bool.random()
        
        // When
        let vm = ExampleViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    func test_ExampleViewModel_isPremium_shouldBeInjectedValue_stress() {
        
        for _ in 0..<10 {
            // Given
            let userIsPremium: Bool = Bool.random()
            
            // When
            let vm = ExampleViewModel(isPremium: userIsPremium)
            
            // Then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    
    func test_ExampleViewModel_dataArray_shouldBeEmpty() {
        // Given
        
        // When
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_ExampleViewModel_dataArray_shouldAddItems() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        vm.addItem(item: "hello")
        
        // Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertEqual(vm.dataArray.count, 1)
    }
    
    func test_ExampleViewModel_dataArray_shouldNotAddBlankString() {
        // Given
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        
        // When
        vm.addItem(item: "")
        
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_ExampleViewModel_dataArray_shouldNotAddBlankString2() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        vm.addItem(item: "")
        
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_ExampleViewModel_dataArray_shouldAddItemsOfRandomString() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        vm.addItem(item: UUID().uuidString)
        
        // Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertEqual(vm.dataArray.count, 1)
    }
    
    func test_ExampleViewModel_dataArray_shouldAddItemsOfRandomString10Times() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
//        let loopCount: Int = 10
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertNotEqual(vm.dataArray.count, 0)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertEqual(vm.dataArray.count, loopCount)
    }
    
    func test_ExampleViewModel_selectedItem_shouldStartAsNil() {
        // Given
        
        // When
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_ExampleViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        vm.selectItem(item: UUID().uuidString)
        
        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_ExampleViewModel_selectedItem_shouldBeSelected() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        // Then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }
    
    func test_ExampleViewModel_selectedItem_shouldBeNotNilWhenSelectingInvalidItemWhenItIsNotEmpty() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        // Select valid item
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        // Select invalid item
        vm.selectItem(item: UUID().uuidString)
        
        // Then
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_ExampleViewModel_selectedItem_shouldBeSelected_stress() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<10)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        vm.selectItem(item: randomItem)
        
        // Then
        XCTAssertFalse(randomItem.isEmpty)
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }
    
    func test_ExampleViewModel_saveItem_shouldThrowError_itemNotFound() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        
        
        // Then
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found error!") { error in
            let returnedError = error as? ExampleViewModel.DataError
            XCTAssertEqual(returnedError, ExampleViewModel.DataError.itemNotfound)
        }
    }
    
    func test_ExampleViewModel_saveItem_shouldThrowError_itemNotFoundWhenItIsNotEmpty() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<10)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // Then
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found error!") { error in
            let returnedError = error as? ExampleViewModel.DataError
            XCTAssertEqual(returnedError, ExampleViewModel.DataError.itemNotfound)
        }
    }
    
    func test_ExampleViewModel_saveItem_shouldThrowError_noData() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<10)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // Then
        do {
            try vm.saveItem(item: "")
        } catch let error {
            let returnedError = error as? ExampleViewModel.DataError
            XCTAssertEqual(returnedError, ExampleViewModel.DataError.noData)
        }
        
        XCTAssertThrowsError(try vm.saveItem(item: ""))

        XCTAssertThrowsError(try vm.saveItem(item: ""), "Should throw No Data error!") { error in
            let returnedError = error as? ExampleViewModel.DataError
            XCTAssertEqual(returnedError, ExampleViewModel.DataError.noData)
        }
    }
    
    func test_ExampleViewModel_saveItem_shouldSaveItem() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1..<10)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        
        // Then
        XCTAssertFalse(randomItem.isEmpty)
        
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    func test_ExampleViewModel_downloadWithEscaping_shouldReturnItems() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after 3 items")
        
        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithEscaping()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_ExampleViewModel_downloadWithCombine_shouldReturnItems() {
        // Given
        let vm = ExampleViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after a items")
        
        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_ExampleViewModel_downloadWithCombine_shouldReturnItems2() {
        // Given
        let items = [
            UUID().uuidString,
            UUID().uuidString,
            UUID().uuidString,
            UUID().uuidString,
            UUID().uuidString
        ]
        let dataService: NewDataServiceProtocol = ExampleDataService(items: items)
        let vm = ExampleViewModel(isPremium: Bool.random(), dataService: dataService)
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after a items")
        
        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertEqual(vm.dataArray.count, items.count)
    }
}
