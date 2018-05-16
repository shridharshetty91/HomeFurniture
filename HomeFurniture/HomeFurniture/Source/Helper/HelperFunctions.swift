//
//  HelperFunctions.swift
//  HomeFurniture
//
//  Created by Shridhar on 16/05/18.
//

import Foundation
import UIKit
import CoreData

func getAppDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func getMainContext() -> NSManagedObjectContext {
    return getAppDelegate().persistentContainer.viewContext
}
