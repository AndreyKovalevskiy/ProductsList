//
//  CoreDataManager.swift
//  ProductsList
//
//  Created by Andrey Kovalevskiy on 29.01.21.
//

import Foundation
import CoreData

class CoreDataManager {

    // MARK: - Properties

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProductsList")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Initializers

    private init() { }

    // MARK: - Methods

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
