//
//  DetailEateriyTableViewCell.swift
//  Eateries
//
//  Created by Aleksey Kabishau on 1022..17.
//  Copyright © 2017 Aleksey Kabishau. All rights reserved.
//

import UIKit

class DetailEateryTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
