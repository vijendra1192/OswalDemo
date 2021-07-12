//
//  File.swift
//  OswalDemo
//
//  Created by Vijendra Yadav on 10/07/21.
//

import Foundation

protocol UserProtocol {
    var name: String {get set}
    var id: Int16 {get set}
}

// This is for Table Cell View
struct UserTableCellViewModel: UserProtocol {
    var name: String
    var id: Int16
}


// Model file
struct User: Codable, UserProtocol {
    var name: String
    var id: Int16
}
