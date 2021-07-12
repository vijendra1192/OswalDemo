//
//  PersistentStorageTests.swift
//  OswalDemoTests
//
//  Created by Vijendra Yadav on 12/07/21.
//

import XCTest
@testable import OswalDemo
import CoreData

class PersistentStorageTests: XCTestCase {
    var coreDataStack: PersistentStorage!
    
    override func setUp() {
        super.setUp()
        coreDataStack = PersistentStorage()
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
    }
    
    func testDeleteRecordBasesOnEntity() {
        coreDataStack.deleteRecordBasesOnEntity(entityName: AppConstant.ENTITY_NAME)
    }

}
