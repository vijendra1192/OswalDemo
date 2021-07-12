//
//  ViewControllerTests.swift
//  OswalDemoTests
//
//  Created by Vijendra Yadav on 12/07/21.
//

import XCTest
@testable import OswalDemo

class ViewControllerTests: XCTestCase {
    
    var sut: ViewController!
    var viewModel: UserListViewModel!
    
    override func setUp() {
        super.setUp()
        
        // Viewcontroller instantitate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        sut.loadViewIfNeeded()
        
        // Viewmodel instantiate
        viewModel = UserListViewModel(delegate: nil)
    }
    
    override  func tearDown() {
        super.tearDown()
        sut = nil
        viewModel = nil
    }
    
    func testViewControllerLoaded() {
        XCTAssertNotNil(sut, "viewcontroller not loaded")
    }
    
    func testViewModelObjectCreated() {
        XCTAssertNotNil(viewModel, "viewmodel not created")
    }
    
    
    func testControllerHasTableView() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.tvLists, "Controller should have a tableview")
    }
    
    func testNumberOfRowsInSection() {
        let lists = viewModel.saveData(model: [UserTableCellViewModel(name: "vijendra", id: 1), UserTableCellViewModel(name: "yadav", id: 2)])
        sut.userListViewModel.users = lists
        
        let numberOfRows = sut.tableView(sut.tvLists, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, lists.count)
        XCTAssertNotNil(numberOfRows)
        XCTAssertNotNil(lists)
        XCTAssertNotNil(sut.userListViewModel.users)
    }
    
    func testCellForRowAtIndexPath() {
        let lists = viewModel.saveData(model: [UserTableCellViewModel(name: "vijendra", id: 1), UserTableCellViewModel(name: "yadav", id: 2)])
        sut.userListViewModel.users = lists
        
        // For row 0
        guard let cell0 = sut.tableView(sut.tvLists, cellForRowAt: IndexPath(row: 0, section: 0)) as? ListTVCell else { return }
        
        // For row 1
        guard let cell1 = sut.tableView(sut.tvLists, cellForRowAt: IndexPath(row: 1, section: 0)) as? ListTVCell else { return }
        
        
        XCTAssertEqual("vijendra", cell0.nameLbl.text)
        XCTAssertEqual("yadav", cell1.nameLbl.text)
    }
    
    func testHasaNewCell() {
        let cell = sut.tvLists.dequeueReusableCell(withIdentifier: AppConstant.USERS_LIST_CELL)
        XCTAssertNotNil(cell, "cell is not created")
    }
    
    func testTrailingSwipeActionsConfigurationForRowAt() {
        let actions = sut.tableView(sut.tvLists, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
    }
}
