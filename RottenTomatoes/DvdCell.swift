//
//  DvdCell.swift
//  RottenTomatoes
//
//  Created by vu on 9/19/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class DvdCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
