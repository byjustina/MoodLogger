//
//  NotesViewController.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/30/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    var isCreatingNewEntry: Bool = true
    
   var entry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didAnswerView.isUserInteractionEnabled = true
        changeAnswerView.isUserInteractionEnabled = true
        if let mood = entry {
            didAnswerView.text = mood.answer1
            changeAnswerView.text = mood.answer2
        } else {
            didAnswerView.text = ""
            changeAnswerView.text = ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save" where entry != nil:
            entry?.answer1 = didAnswerView.text ?? ""
            entry?.answer2 = changeAnswerView.text ?? ""
            
            CoreDataHelper.saveEntry()
            
        case "save" where entry == nil:
            let entry = CoreDataHelper.newEntry()
            entry.answer1 = didAnswerView.text ?? ""
            entry.answer2 = changeAnswerView.text ?? ""
            entry.timestamp = Date()
            
            CoreDataHelper.saveEntry()
            
            //send entry to calendar view controller
            
            
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
    @IBAction func unwindToNotes(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        if isCreatingNewEntry == true {
            CoreDataHelper.deleteEntry(entry: entry!)
            performSegue(withIdentifier: "unwindCancel", sender: nil)
        } else {
            performSegue(withIdentifier: "unwindToCalendar", sender: nil)
        }
        
    }

}

extension NotesViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NotesViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
