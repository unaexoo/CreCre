//
//  CoreDataManager.swift
//  CreCre
//
//  Created by 윤혜주 on 9/18/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager(container: PersistenceController.shared.container)

    private let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func delete <T: NSManagedObject>(_ object: T) {
        context.delete(object)
        saveContext()
    }

}
