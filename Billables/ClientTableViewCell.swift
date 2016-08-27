//
//  ClientTableViewCell.swift
//  Billables
//
//  Created by Theodore Prekop on 8/16/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class is responisble for cells in the client table view

import UIKit

class ClientTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var client: UILabel!
    @IBOutlet weak var clientImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
