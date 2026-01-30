//
//  CoreDataStack.swift
//  Lunio Days
//
//  Created by Ivan Solohub on 29.01.2026.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "LunioDays")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData error: \(error)")
            }
        }
    }

    func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
