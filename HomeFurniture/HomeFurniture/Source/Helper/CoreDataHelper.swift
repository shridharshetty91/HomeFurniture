//
//  CoreDataHelper.swift
//  HomeFurniture
//
//  Created by Shridhar on 17/05/18.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    private static var sharedInstance : CoreDataHelper!
    
    class var shared: CoreDataHelper {
        if (sharedInstance == nil) {
            sharedInstance = CoreDataHelper()
        }
        return sharedInstance
    }
    
    private init() {
    }
    
    class func destroyInstance() {
        sharedInstance = nil
    }
    
    static var persistantContainer: NSPersistentContainer = {
        return HelperFunctions.getAppDelegate().persistentContainer
    }()
    
    static var managedContext: NSManagedObjectContext = {
        return CoreDataHelper.persistantContainer.viewContext
    }()
    
    static func saveContext() {
        DispatchQueue.main.async {
            HelperFunctions.getAppDelegate().saveContext()
        }
    }
}
