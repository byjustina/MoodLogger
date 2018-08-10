//
//  HomeScreenViewController.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/30/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    var moods = [Entry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func unwindToHomescreen(_ segue: UIStoryboardSegue) {
        moods = CoreDataHelper.retrieveEntry()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        //showing calendar?
        if identifier == "showCalendar" {
            
        } else {
            //adding a new Entry
            
            //create a newEntry from CoreDataHelper.newEntry()
            let newEntry = CoreDataHelper.newEntry()
            
            //get the selected mood and turn it into an Entry.Moods value
            let newMoodValueFromButton: Entry.Moods
            
            switch identifier {
            case "amazing":
                newMoodValueFromButton = .Amazing
            case "good":
                newMoodValueFromButton = .Good
            case "neutral":
                newMoodValueFromButton = .Neutral
            case "bad":
                newMoodValueFromButton = .Bad
            case "terrible":
                newMoodValueFromButton = .Terrible
            default:
                fatalError("segue identifier not handled: \(identifier)")
            }
            
            //update the newEntry values: timestamp, mood
            newEntry.mood = newMoodValueFromButton
            newEntry.timestamp = datePicker.date
            
            guard let viewController = segue.destination as? NotesViewController else {
                fatalError("storyboard not set up correctly")
            }
            
            viewController.entry = newEntry
        }
    }
    
    
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var amazingButton: UIButton!
    
    @IBOutlet weak var goodButton: UIButton!
    
    @IBOutlet weak var neutralButton: UIButton!

    @IBOutlet weak var badButton: UIButton!

    @IBOutlet weak var terribleButton: UIButton!

    @IBOutlet weak var calendarButton: UIButton!
    
    @IBAction func amazingButtonTapped(_ sender: UIButton) {
        amazingButton.layer.cornerRadius = 10
        amazingButton.clipsToBounds = true
    }
    
}
