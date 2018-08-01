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

    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        moods = CoreDataHelper.retrieveMoods()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        //showing calendar?
        if identifier == "showCalendar" {
            
        } else {
            //addding a new Entry
            
            
            
            //create a newEntry from CoreDataHelper.newEntry()
            
            
            //get the selected mood and turn it into a Entry.Moods value
            
            
            //update the newEntry values: timestamp, mood
            
            
        }
        
        
        switch identifier {
        case "amazing":
            break
        case "good":
            break
        case "neutral":
            break
        case "bad":
            break
        case "terrible":
            break
        case "showCalendar":
            print("Transitioning to the Calendar View Controller")
            
        default:
            print("unexpected segue identifier")
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

//    let btnImage = UIImage(named: "image")
//    btnTwo.setImage(btnImage , for: UIControlState.normal)
    
}
