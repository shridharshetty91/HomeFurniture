//
//  FurnitureManager.swift
//  HomeFurniture
//
//  Created by Shridhar on 5/19/18.
//

import Foundation
import CoreData

class FurnitureManager {
    
    lazy private (set) var userFurniture: UserFurniture? = {
        do {
            let fetchedObjects = try CoreDataHelper.managedContext.fetch(UserFurniture.fetchRequest()) as! [UserFurniture]
            if (fetchedObjects.count == 0) { //DB is Empty
                return UserFurniture(context: CoreDataHelper.managedContext)
            }
            else{
                return fetchedObjects.first!
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }()
    
    func validate(input: FurnitureInput) -> Bool {
        if input.name == nil || input.name!.isEmpty ||
            input.imageData == nil{
            return false
        }
        return true
    }
    
    func hasChanges(furniture: Furniture, input: FurnitureInput) -> Bool {
        if furniture.name != input.name ||
            furniture.details != input.details {
            return true
        }
        
        return false
    }
    
    func deleteFurniture(furniture: Furniture) {
        userFurniture?.removeFromFurnitures(furniture)
        CoreDataHelper.managedContext.delete(furniture)
        CoreDataHelper.saveContext()
    }
    
    func addFurniture(input: FurnitureInput) -> Furniture {
        let furniture = Furniture(context: CoreDataHelper.managedContext)
        furniture.createdDate = Date()
        setFurnitureValues(furniture: furniture, input: input)
        userFurniture?.addToFurnitures(furniture)
        CoreDataHelper.saveContext()
        return furniture
    }
    
    func updateFurniture(furniture: Furniture, input: FurnitureInput) -> Furniture {
        setFurnitureValues(furniture: furniture, input: input)
        CoreDataHelper.saveContext()
        return furniture
    }
    
    private func setFurnitureValues(furniture: Furniture, input: FurnitureInput) {
        furniture.name = input.name
        furniture.details = input.details
        furniture.imageData = input.imageData
        furniture.updatedDate = Date()
    }
    
    func isFurnitureExists(furnitureWithName: String) -> Bool {
        let furnitureFetchRequest: NSFetchRequest<NSFetchRequestResult> = Furniture.fetchRequest()
        furnitureFetchRequest.predicate = NSPredicate(format: "name ==[c] %@", furnitureWithName)
        
        var isExists = false
        do {
            let fetchedObjects = try CoreDataHelper.managedContext.fetch(furnitureFetchRequest) as! [Furniture]
            if fetchedObjects.count > 0 {
                isExists = true
            }
        } catch{
            print(error.localizedDescription)
        }
        
        return isExists
    }
}

struct FurnitureInput {
    var name: String?
    var details: String?
    var imageData: Data?
    
    init() {
        
    }
}
