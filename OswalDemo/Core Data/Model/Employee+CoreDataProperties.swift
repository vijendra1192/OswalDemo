//
//  Employee+CoreDataProperties.swift
//  OswalDemo
//
//  Created by Vijendra Yadav on 10/07/21.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int16

}

extension Employee : Identifiable {

}
