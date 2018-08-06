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
    
    /** fetch all of the entries from core data */
    static func retrieveEntry() -> [Entry] {
        do {
            let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    
    /** fetch all of the entries that were added to the same day as the given date */
    static func retrieveEntry(for date: Date) -> [Entry] {
        do {
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond, .calendar], from: date)
            dateComponents.hour = 0
            dateComponents.minute = 0
            dateComponents.second = 0
            dateComponents.nanosecond = 0
            guard let dateFromComponents = dateComponents.date else {
                fatalError("failed to create a date from dateComponents")
            }
            
            let dateMidnight = dateFromComponents
            let day: TimeInterval = 60*60*24
            let afterDateMidnight = dateMidnight.addingTimeInterval(day)
            
            let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
            fetchRequest.predicate = NSPredicate(format: "(%@ <= timestamp) AND (timestamp < %@)", dateMidnight as NSDate, afterDateMidnight as NSDate)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
}



