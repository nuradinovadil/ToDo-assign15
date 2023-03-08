//
//  SectionManager.swift
//  ToDoey
//
//  Created by Nuradinov Adil on 08/03/23.
//

import Foundation
import UIKit

protocol SectionManagerDelegate {
    func didUpdateSections(with models: [ToDoeySection])
    func didFail(with error: Error)
}

struct SectionManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: SectionManagerDelegate?
    
    static var shared = SectionManager()
    
    func fetchSections(with text: String = "") {
        do {
            let request = ToDoeySection.fetchRequest()
            if text != "" {
                let predicate = NSPredicate(format: "name CONTAINS %@", text)
                request.predicate = predicate
            }
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func createSections(with name: String) {
        let newSection = ToDoeySection(context: context)
        newSection.name = name
        do {
            try context.save()
            let request = ToDoeySection.fetchRequest()
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func deleteSection(section: ToDoeySection) {
        context.delete(section)
        do {
            try context.save()
            let request = ToDoeySection.fetchRequest()
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            print("Following error appeared: ", error)
        }
    }
    
    func updateSection(section: ToDoeySection, newName: String) {
        section.name = newName
        do {
            try context.save()
            let request = ToDoeySection.fetchRequest()
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            print("Following error appeared: ", error)
        }
    }
}

extension SectionManagerDelegate {
    func didFail(with error: Error) {
        print("Following error appeared: ", error)
    }
}
