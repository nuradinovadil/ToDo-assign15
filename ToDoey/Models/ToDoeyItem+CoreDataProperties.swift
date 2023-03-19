//
//  ToDoeyItem+CoreDataProperties.swift
//  
//
//  Created by Nuradinov Adil on 17/03/23.
//
//

import Foundation
import CoreData


extension ToDoeyItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoeyItem> {
        return NSFetchRequest<ToDoeyItem>(entityName: "ToDoeyItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var desc: String?
    @NSManaged public var image: Data?
    @NSManaged public var section: ToDoeySection?

}
