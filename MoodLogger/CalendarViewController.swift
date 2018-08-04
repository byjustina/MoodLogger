//
//  CalendarViewController.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/24/18.
//  Copyright © 2018 Make School. All rights reserved.
//
import Foundation
import UIKit
import JTAppleCalendar


class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var entriesForSelectedDay = [Entry]()
    var date: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let outsideMonthColor: UIColor = .darkGray
    let monthColor = UIColor(red: 253/255, green: 253/255, blue: 253/255, alpha: 1.0)
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor(red: 100/255, green: 200/255, blue: 200/255, alpha: 1.0)
    
    override func viewDidLoad() {
       // UICollectionView.layer.borderColor = UIColor.white
        super.viewDidLoad()
        //existing
        tableView.delegate = self
        tableView.dataSource = self
        
        setupCalendarView()
//        entriesForSelectedDay = CoreDataHelper.retrieveEntry()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let today = Date()
        calendarView.selectDates([today])
        calendarView.scrollToDate(today, animateScroll: false)
        entriesForSelectedDay = CoreDataHelper.retrieveEntry(for: today)
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entriesForSelectedDay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mood = entriesForSelectedDay[indexPath.row]
        
        self.performSegue(withIdentifier: "editSegue", sender: mood)
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "edit")
//        let segue = UIStoryboardSegue(identifier: "editSegue", source: self, destination: vc)
//        self.prepare(for: segue, sender: mood)
      
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "editSegue":
            let mood = sender as! Entry
            let viewController = segue.destination as! NotesViewController
            viewController.isCreatingNewEntry = false
            viewController.entry = mood
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodTableViewCell", for: indexPath) as! MoodTableViewCell
        
        let mood = entriesForSelectedDay[indexPath.row]
        cell.moodLabel.text = mood.mood.stringValue
        cell.timestampLabel.text = mood.timestamp?.convertToString() ?? "unknown"
        
        return cell
        
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellSelected(view: JTAppleCell? , cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = "     " + self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = "   " + self.formatter.string(from: date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2019 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
        
        //fetch entries based off of the date from core data
        let entries = CoreDataHelper.retrieveEntry(for: date)
        
        //create a var that has the count of the entries found
        let numberOfEntries = entries.count
        
        //swtich on the count var
        switch numberOfEntries {
        case 0:
            //case 0: hide all the lines
            myCustomCell.entry1.alpha = 0
            myCustomCell.entry2.alpha = 0
            myCustomCell.entry3.alpha = 0
            myCustomCell.entry4.alpha = 0
        case 1:
            //case 1: update the first line with the color of the first entry, and hide all other lines
            let firstEntry = entries[0]
            let firstColor = firstEntry.mood.colorValue
            myCustomCell.entry1.backgroundColor = firstColor
            myCustomCell.entry1.alpha = 1
            myCustomCell.entry2.alpha = 0
            myCustomCell.entry3.alpha = 0
            myCustomCell.entry4.alpha = 0
        case 2:
            let secondEntry = entries[1]
            let secondColor = secondEntry.mood.colorValue
            myCustomCell.entry2.backgroundColor = secondColor
            myCustomCell.entry1.alpha = 0
            myCustomCell.entry2.alpha = 1
            myCustomCell.entry3.alpha = 0
            myCustomCell.entry4.alpha = 0
        case 3:
            let thirdEntry = entries[2]
            let thirdColor = thirdEntry.mood.colorValue
            myCustomCell.entry3.backgroundColor = thirdColor
            myCustomCell.entry1.alpha = 0
            myCustomCell.entry2.alpha = 0
            myCustomCell.entry3.alpha = 1
            myCustomCell.entry4.alpha = 0
        case 4:
            let fourthEntry = entries[3]
            let fourthColor = fourthEntry.mood.colorValue
            myCustomCell.entry4.backgroundColor = fourthColor
            myCustomCell.entry1.alpha = 0
            myCustomCell.entry2.alpha = 0
            myCustomCell.entry3.alpha = 0
            myCustomCell.entry4.alpha = 1
        default: //unhide the plus icon
            break
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "myCustomCell", for: indexPath) as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        handleCellSelected(view: myCustomCell, cellState: cellState)
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
       
        entriesForSelectedDay = CoreDataHelper.retrieveEntry(for: date)
        tableView.reloadData()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let moodToDelete = entriesForSelectedDay[indexPath.row]
//            CoreDataHelper.deleteEntry(entry: moodToDelete)
//            entriesForSelectedDay = CoreDataHelper.retrieveEntry()
        let moodToDelete = entriesForSelectedDay[indexPath.row]
        CoreDataHelper.deleteEntry(entry: moodToDelete)
        entriesForSelectedDay.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        //tableView.reloadData()
        //each cell of calendar shows the same entry for every day, crashes when trying to delete, colored bars on calendar cell too thick and when another entry is entered the color on the calendar is replaced by that new entry, second question on notes screen disappears
    }    
}


