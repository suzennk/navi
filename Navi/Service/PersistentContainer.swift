//
//  PersistentContainer.swift
//  Navi
//
//  Created by Susan Kim on 2021/08/18.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
            let context = backgroundContext ?? viewContext
            guard context.hasChanges else { return }
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: \(error), \(error.userInfo)")
            }
        }
}
