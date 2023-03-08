//
//  DataManager.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 07/03/23.
//

import Foundation
import UIKit

protocol ItemManagerDelegate {
    func didUpdateItems(with models: [ToDoeyItem])
    func didFailWithError(error: Error)
}

struct ItemManager {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var delegate: ItemManagerDelegate?

    static var shared = ItemManager()

    func fetchItems(for section: ToDoeySection, with text: String = "") {
        do {
            let request = ToDoeyItem.fetchRequest()
            let sectionPredicate = NSPredicate(format: "section == %@", section)
            var predicates = [sectionPredicate]
            if !text.isEmpty {
                let textPredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
                predicates.append(textPredicate)
            }
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.predicate = compoundPredicate
            let desc = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [desc]
            let models = try context.fetch(request)
            delegate?.didUpdateItems(with: models)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }

    func createItem(for section: ToDoeySection, with name: String) {
        let newItem = ToDoeyItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.section = section
        do {
            try context.save()
            fetchItems(for: section)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }

    func deleteItem(item: ToDoeyItem) {
        context.delete(item)
        do {
            try context.save()
            if let section = item.section {
                fetchItems(for: section)
            }
        } catch {
            print("Following error appeared: ", error)
        }
    }

    func updateItem(item: ToDoeyItem, newName: String) {
        item.name = newName
        do {
            try context.save()
            if let section = item.section {
                fetchItems(for: section)
            }
        } catch {
            print("Following error appeared: ", error)
        }
    }
}

