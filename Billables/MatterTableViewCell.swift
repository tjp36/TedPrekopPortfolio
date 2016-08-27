//
//  MatterTableViewCell.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class is resposible for the cells in the MatterTableView controller

import UIKit

class MatterTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var client: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
