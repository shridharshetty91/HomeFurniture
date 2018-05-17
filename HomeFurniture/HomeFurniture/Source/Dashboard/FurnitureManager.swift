//
//  FurnitureManager.swift
//  HomeFurniture
//
//  Created by Shridhar on 17/05/18.
//

import UIKit
import CoreData

class FurnitureManager {

    var userFurniture: UserFurniture!
    
    private static var sharedInstance : FurnitureManager!
    
    class var shared: FurnitureManager {
        if (sharedInstance == nil) {
            sharedInstance = FurnitureManager()
        }
        return sharedInstance
    }
    
    private init() {
        initializeFurnitureManager()
    }
    
    private func initializeFurnitureManager() {
        
        do {
            let fetchedObjects = try CoreDataHelper.managedContext.fetch(UserFurniture.fetchRequest()) as! [UserFurniture]
            if (fetchedObjects.count == 0) { //DB is Empty
                self.userFurniture = UserFurniture(context: CoreDataHelper.managedContext)
            }
            else{
                self.userFurniture = fetchedObjects.first!
            }
        } catch {
            self.userFurniture = UserFurniture(context: CoreDataHelper.managedContext)
        }
    }
    
    func deleteFurniture(furniture: Furniture) {
        userFurniture.removeFromFurnitures(furniture)
        CoreDataHelper.managedContext.delete(furniture)
        CoreDataHelper.saveContext()
    }
    
    func addFurniture(name: String, details: String?, imageData: Data) -> Furniture {
        let furniture = Furniture(context: CoreDataHelper.managedContext)
        furniture.name = name
        furniture.details = details
        furniture.image = imageData
        furniture.createdDate = Date()
        furniture.updatedDate = Date()
        userFurniture.addToFurnitures(furniture)
        CoreDataHelper.saveContext()
        return furniture
    }
    
    func updateFurniture(furniture: Furniture, name: String, details: String?, imageData: Data) -> Furniture {
        furniture.name = name
        furniture.details = details
        furniture.image = imageData
        furniture.updatedDate = Date()
        CoreDataHelper.saveContext()
        return furniture
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
