//
//  Constants.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 16/03/23.
//

import Foundation

struct Constants {
    
}

enum Priority: Int, CaseIterable {
    case high = 1, medium = 2, low = 3
    
    static let allValues = [high, medium, low]
}
