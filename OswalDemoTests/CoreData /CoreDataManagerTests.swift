//
//  CoreDataManagerTests.swift
//  OswalDemoTests
//
//  Created by Vijendra Yadav on 11/07/21.
//

import XCTest
import CoreData
@testable import OswalDemo

class TestCoreDataStack: PersistentStorage {
  override init() {
    super.init()

    // 1
    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    // 2
    let container = NSPersistentContainer(
      name: PersistentStorage.modelName,
      managedObjectModel: PersistentStorage.model)

    // 3
    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    // 4
    persistentContainer = container
  }
}
