//
//  ToDoeySection+CoreDataProperties.swift
//  
//
//  Created by Nuradinov Adil on 17/03/23.
//
//

import Foundation
import CoreData


extension ToDoeySection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoeySection> {
        return NSFetchRequest<ToDoeySection>(entityName: "ToDoeySection")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension ToDoeySection {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ToDoeyItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ToDoeyItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
