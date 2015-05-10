//
//  MoodTableViewCell.swift
//  Today
//
//  Created by Guest-Admin on 5/9/15.
//  Copyright (c) 2015 Viacom. All rights reserved.
//

import UIKit

class MoodTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weather: UIImageView!
    @IBOutlet weak var mood: UILabel!
    @IBOutlet weak var moodIcon: UIImageView!
    @IBOutlet weak var greyBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
