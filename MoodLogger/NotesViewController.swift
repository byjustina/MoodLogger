//
//  NotesViewController.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/30/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        didAnswerView.text = ""
        changeAnswerView.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case "save":
            let mood = Mood()
            mood.title = didAnswerView.text ?? ""
            mood.content = changeAnswerView.text ?? ""
            mood.timestamp = Date()

            let destination = segue.destination as! CalendarViewController
            destination.moods.append(mood)

        default:
            print("unexpected segue identifier")
        }
    }

    @IBOutlet weak var didQuestionLabel: UILabel!
    @IBOutlet weak var didAnswerView: UITextView!
    @IBOutlet weak var changeQuestionLabel: UILabel!
    @IBOutlet weak var changeAnswerView: UITextView!
}
