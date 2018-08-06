//
//  MoodTableViewCell.swift
//  MoodLogger
//
//  Created by Justina Chen on 7/29/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit

class MoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var stripe: UIImageView!
}
