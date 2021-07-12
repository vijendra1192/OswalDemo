//
//  PersistentStorage.swift
//  OswalDemo
//
//  Created by Vijendra Yadav on 10/07/21.
//

import Foundation
import CoreData

class PersistentStorage {
    
    public init() {}
    
    // For testing purpose
    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    public static let modelName = AppConstant.MODEL_NAME
    // End
    
    
    static let shared = PersistentStorage()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OswalDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteRecordBasesOnEntity(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            guard results.count > 0 else { return }
            
            results.forEach { result in
                let managedObjects: NSManagedObject = result as! NSManagedObject
                context.delete(managedObjects)
            }
            saveContext()
        } catch {
            print("error in deleting \(error.localizedDescription)")
        }
    }
}
