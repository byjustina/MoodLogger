//
//  CoreDataHelper.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/24/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newEntry() -> Entry {
        let mood = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context) as! Entry
        return mood
    }
    
    static func saveEntry() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
   static func deleteEntry(entry: Entry) {
        context.delete(entry)
        saveEntry()
    }
    
    static func retrieveMoods() -> [Entry] {
        do {
            let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
}



