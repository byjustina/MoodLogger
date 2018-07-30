//
//  ViewController.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/24/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import JTAppleCalendar


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let outsideMonthColor: UIColor = .darkGray
    let monthColor = UIColor(red: 100, green: 255, blue: 200, alpha: 1.0)
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor(red: 100, green: 200, blue: 300, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodTableViewCell", for: indexPath) as! MoodTableViewCell
        
        cell.moodLabel.text = "mood"
        cell.timestampLabel.text = "timestamp"
        
        return cell
    }
    
    func setupCalendarView() {
        // Set up calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        // Set up labels
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
        self.year.text = "   " + self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = "   " + self.formatter.string(from: date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: JTAppleCalendarViewDataSource {
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

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "myCustomCell", for: indexPath) as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        // myCustomCell.dateLabel.text = cellState.text
        handleCellSelected(view: myCustomCell, cellState: cellState)
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    
}
