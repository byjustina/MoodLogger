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
    
    static func newMood() -> Mood {
        let mood = NSEntityDescription.insertNewObject(forEntityName: "Mood", into: context) as! Mood
        return mood
    }
    
    static func saveMood() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
   static func delete(mood: Mood) {
        context.delete(mood)
        saveMood()
    }
    
    static func retrieveMoods() -> [Mood] {
        do {
            let fetchRequest = NSFetchRequest<Mood>(entityName: "Mood")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
}



