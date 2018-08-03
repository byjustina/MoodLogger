//
//  Entry+Moods.swift
//  MoodLogger
//
//  Created by Justina Chen on 8/1/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit.UIColor

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
            case Moods.Good.stringValue:
                return Moods.Good
            case Moods.Neutral.stringValue:
                return Moods.Neutral
            case Moods.Bad.stringValue:
                return Moods.Bad
            case Moods.Terrible.stringValue:
                return Moods.Terrible
            default:
                return nil
            }
        }
        
        var colorValue: UIColor {
            
            switch self {
            case .Amazing:
                return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            case .Good:
                return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            case .Neutral:
                return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            case .Bad:
                return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            case .Terrible:
                return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
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
}
