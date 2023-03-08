//
//  ToDoeyItem+CoreDataProperties.swift
//  
//
//  Created by Nuradinov Adil on 08/03/23.
//
//

import Foundation
import CoreData


extension ToDoeyItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoeyItem> {
        return NSFetchRequest<ToDoeyItem>(entityName: "ToDoeyItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var section: ToDoeySection?

}
