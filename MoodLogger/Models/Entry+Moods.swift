//
//  Entry+Moods.swift
//  MoodLogger
//
//  Created by Justina Chen on 8/1/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation

extension Entry {
    
    enum Moods: Int16 {
        case Amazing
        case Good
        case Neutral
        case Bad
        case Terrible
        
        func stringToMood(string: String) -> Moods? {
            switch string {
            case Moods.Amazing.stringValue:
                return Moods.Amazing
            default:
                return nil
            }
        }
        
        var stringValue: String {
            switch self {
            case .Amazing:
                return "Amazing"
            case .Good:
                return "Good"
            case .Neutral:
                return "Neutral"
            case .Bad:
                return "Bad"
            case .Terrible:
                return "Terrible"
            }
        }
    }
    
    var mood: Moods {
        set {
            let newMoodValue = newValue
            let newMoodRawValue = newMoodValue.rawValue
            
            self.moodValue = newMoodRawValue
        }
        get {
            guard let moodFromValue = Moods(rawValue: moodValue) else {
                fatalError("moodValue: \(moodValue) is out of bounds of Entry.Moods enum")
            }
            
           return moodFromValue
        }
    }
    
    func hi() {
        print(Entry().mood)
        Entry().mood = .Amazing
    }
}
