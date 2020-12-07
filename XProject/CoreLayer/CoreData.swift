//
//  CoreData.swift
//  XProject
//
//  Created by Максим Локтев on 26.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import CoreData

internal class CoreData {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "XProject")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchObjects<T: NSManagedObject>(entity: T.Type,
                                          predicate: NSPredicate? = nil,
                                          sortDescriptors: [NSSortDescriptor]? = nil,
                                          context: NSManagedObjectContext,
                                          result: (Result<[T], APIError>) -> Void) {
        
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            let objects = try context.fetch(request)
            result(.success(objects))
        } catch let error as NSError {
            result(.failure(.fetchCoreDataObjectError(error)))
        }
    }
    
    func fetchObject<T: NSManagedObject>(entity: T.Type,
                                         predicate: NSPredicate? = nil,
                                         sortDescriptors: [NSSortDescriptor]? = nil,
                                         context: NSManagedObjectContext,
                                         result: (Result<T, APIError>) -> Void) {
        
        let request = NSFetchRequest<T>(entityName: String(describing: entity))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        //request.fetchLimit = 1
        #warning("bag")
        
        do {
            if let object = try context.fetch(request).last {
                result(.success(object))
            } else {
                result(.failure(.faildExtractOptionalValue))
            }
        } catch let error as NSError {
            result(.failure(.fetchCoreDataObjectError(error)))
        }
    }
    
    func fetchObjectById<T: NSManagedObject>(entity: T.Type,
                                             urlID: URL,
                                             context: NSManagedObjectContext,
                                             result: (Result<T, APIError>) -> Void) {
        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: urlID) else {
            result(.failure(APIError.faildExtractOptionalValue))
            return
        }
        
        do {
            if let fetchedObject = try context.existingObject(with: objectID) as? T {
                result(.success(fetchedObject))
            } else {
                result(.failure(.faildExtractOptionalValue))
            }
        } catch {
            result(.failure(.fetchCoreDataObjectError(error)))
        }
    }
    
    func delete(_ objects: [NSManagedObject],
                in context: NSManagedObjectContext,
                result: (Result<Void, APIError>) -> Void) {
        
        objects.forEach { object in
            context.delete(object)
        }

        do {
            try context.save()
            result(.success(()))
        } catch let error as NSError {
            result(.failure(.deleteCoreDataObjectsError(error)))
        }
    }

    func deleteAllObjects<T: NSManagedObject>(entity: T.Type, result: (Result<Void, APIError>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            result(.success(()))
        } catch let error as NSError {
            result(.failure(.deleteCoreDataObjectsError(error)))
        }
    }

}
