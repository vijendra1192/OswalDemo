//
//  UserListViewModelTests.swift
//  OswalDemoTests
//
//  Created by Vijendra Yadav on 11/07/21.
//

import XCTest
@testable import OswalDemo
import CoreData

class UserListViewModelTests: XCTestCase {
    
    // MARK: - Properties
    var viewModel: UserListViewModel!
    var coreDataStack: PersistentStorage!
    
    override func setUp() {
        super.setUp()
        coreDataStack = PersistentStorage()
        viewModel = UserListViewModel(delegate: self)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDataStack = nil
    }
    
    func testSaveData() {
        // Arrange & Act
        let lists = viewModel.saveData(model: [UserTableCellViewModel(name: "vijendra", id: 1), UserTableCellViewModel(name: "yadav", id: 2)])
        
        
        // Assert
        XCTAssertNotNil(lists, "list should not be nil")
        XCTAssertTrue(lists.count == 2, "count should be 2")
        XCTAssertTrue(lists.first?.name == "vijendra")
        XCTAssertTrue(lists.last?.name == "yadav")
        XCTAssertNotNil(lists.first?.id)
        XCTAssertNotNil(lists.first?.name)
    }
    
    func testFetchEmployee() {
        // Arrange & Act
        let lists = viewModel.saveData(model: [UserTableCellViewModel(name: "vijendra", id: 1), UserTableCellViewModel(name: "yadav", id: 2)])
        
        let employees = viewModel.fetchEmployee()
        
        // Assert
        XCTAssertTrue(employees.count == 2, "count should be 2")
        XCTAssertTrue(employees.count == lists.count, "count should be 10")
        XCTAssertTrue(employees.first?.name == lists.first?.name)
        XCTAssertTrue(employees.first?.name == "vijendra")
        XCTAssertTrue(employees.first?.name == "vijendra")
        XCTAssertNotNil(lists)
        XCTAssertNotNil(employees)
    }
    
    func testDeleteEmployee() {
        
        // Arrange & Act
        let lists = viewModel.saveData(model: [UserTableCellViewModel(name: "vijendra", id: 1), UserTableCellViewModel(name: "yadav", id: 2)])
        
        var employees = viewModel.fetchEmployee()
        
        // Assert
        XCTAssertTrue(employees.count == 2, "count should be 2")
        XCTAssertTrue(employees.count == lists.count, "count should be 10")
        
        viewModel.deleteEmployee(at: lists.first?.id ?? 0)
        
        // Act
        employees = viewModel.fetchEmployee()
        
        // Assert
        XCTAssertTrue(employees.count == 1, "count should be 1")
        XCTAssertTrue(employees.count != lists.count, "count should be 1")
    }
    
    func testEmployeeListApiCallWithResponse() {
        // Arrange
        let expectations = self.expectation(description: "validate_return_response")
        
        // Act
        viewModel.employeeListApiCallWithResponse { (results) in
            print("result in test-->> \(results)")

            // Assert
            XCTAssertNotNil(results)
            XCTAssertTrue(results.count == 10, "count should be")
            XCTAssertEqual("Leanne Graham", results.first?.name)
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testEmployeeListApiCall() {
        // Arrange & Act
        let lists = viewModel.saveData(model: [UserTableCellViewModel(name: "vijendra", id: 1), UserTableCellViewModel(name: "yadav", id: 2)])
        
        // Assert
        viewModel.employeeListApiCall()
    }
    
}

extension UserListViewModelTests: ViewControllerDelegate {}
