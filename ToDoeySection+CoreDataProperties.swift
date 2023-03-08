//
//  ToDoeySection+CoreDataProperties.swift
//  
//
//  Created by Nuradinov Adil on 08/03/23.
//
//

import Foundation
import CoreData


extension ToDoeySection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoeySection> {
        return NSFetchRequest<ToDoeySection>(entityName: "ToDoeySection")
    }

    @NSManaged public var name: String?
    @NSManaged public var items: ToDoeyItem?

}
