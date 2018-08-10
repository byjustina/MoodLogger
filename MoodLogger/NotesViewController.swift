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
        
        //        Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        didAnswerView.isUserInteractionEnabled = true
        //        changeAnswerView.isUserInteractionEnabled = true
        if let mood = entry {
            didAnswerView.text = mood.answer1
            changeAnswerView.text = mood.answer2
        } else {
            didAnswerView.text = ""
            changeAnswerView.text = ""
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    /** check if the view is pushed up or not */
    var isViewElevated: Bool {
        return view.frame.origin.y != 0
    }
    
    private var keyboardRect: CGRect!
    
    func pushUpViewIfNeeded() {
        if isViewElevated == false {
            UIView.animate(withDuration: 0.15) {
                self.view.frame.origin.y = -self.keyboardRect.height + 64
            }
        }
    }
    
    func pushDownViewIfNeeded() {
        if isViewElevated {
            UIView.animate(withDuration: 0.15) {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.keyboardRect = keyboardRect
        
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            //            pushUpViewIfNeeded()
        } else {
            pushDownViewIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save":
            entry?.answer1 = didAnswerView.text ?? ""
            entry?.answer2 = changeAnswerView.text ?? ""
            
            CoreDataHelper.saveEntry()
            if isCreatingNewEntry == true {
                guard let viewController = segue.destination as? CalendarViewController else {
                    fatalError("storyboard not set up correctly")
                }
                
                viewController.newEntry = entry
                
            }
            
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

extension NotesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === self.didAnswerView {
            pushDownViewIfNeeded()
        } else if textView === self.changeAnswerView {
            pushUpViewIfNeeded()
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
