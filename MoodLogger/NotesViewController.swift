//
//  NotesViewController.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/30/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
   var mood: Mood?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if let mood = mood {
            didAnswerView.text = mood.title
            changeAnswerView.text = mood.content
        } else {
            didAnswerView.text = ""
            changeAnswerView.text = ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save" where mood != nil:
            mood?.title = didAnswerView.text ?? ""
            mood?.content = changeAnswerView.text ?? ""
            mood?.timestamp = Date()

            CoreDataHelper.saveMood()
            
        case "save" where mood == nil:
            let mood = CoreDataHelper.newMood()
            mood.title = didAnswerView.text ?? ""
            mood.content = changeAnswerView.text ?? ""
            mood.timestamp = Date()
            
            CoreDataHelper.saveMood()
            
        case "cancel":
            print("cancel bar button item tapped")
            
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var didQuestionLabel: UILabel!
    @IBOutlet weak var didAnswerView: UITextView!
    @IBOutlet weak var changeQuestionLabel: UILabel!
    @IBOutlet weak var changeAnswerView: UITextView!
}
