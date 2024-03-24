//
//  GenericCoreDataService.swift
//  BinanceBackTestMac
//
//  Created by Lado Tsivtsivadze on 3/19/24.
//

import Foundation
import CoreData
import AppKit

class CoreDataGenericService<T: NSManagedObject> {
    
    // The managed object context from the persistent container
    let context: NSManagedObjectContext = {
        (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    let container: NSPersistentContainer = {
        (NSApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    
    // Create a new object of type T in Core Data
    func create(entity: EntityName) -> T {
        let entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: context)!
        let object = T(entity: entity, insertInto: context)
        return object
    }
    
    // Fetch all objects of type T from Core Data
    func fetchAll(entity: EntityName, descriptor: NSSortDescriptor? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        if let descriptor = descriptor {
            fetchRequest.sortDescriptors = [descriptor]
        }
        do {
            let entities = try self.context.fetch(fetchRequest) as? [T] ?? []
            return entities
        } catch {
            print("error fetching from core data \(error)")
            return []
        }
    }
    
    // Fetch portion of objects of type T from Core Data
    func fetchObjects(quantity: Int, entity: EntityName, descriptor: NSSortDescriptor? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        //fetchRequest.fetc =
        if let descriptor = descriptor {
            fetchRequest.sortDescriptors = [descriptor]
        }
        context.perform {
            do {
                let entities = try self.context.fetch(fetchRequest) as? [T] ?? []
                completion(.success(entities))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Fetch an object of type T from Core Data by its objectID
    func fetchByID(objectID: NSManagedObjectID) -> T? {
        return context.object(with: objectID) as? T
    }
    
    // Delete an object of type T from Core Data
    func delete(object: T) {
        context.delete(object)
    }
    
    // delete all objects
    func deleteAll(entity: EntityName) throws {
        let entities = self.fetchAll(entity: entity)
        for entity in entities {
            context.delete(entity)
            self.save()
        }
    }
    
    // Save changes to Core Data
    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}

enum EntityName: String {
    case binanceCandle = "BinanceCandle"
    case binanceComboCandle = "BinanceComboCandle"
}
