//
//  CatsTableViewCell.swift
//  EasyLife
//
//  Created by hackeru on 18 Adar 5777.
//  Copyright © 5777 hackeru. All rights reserved.
//

import UIKit

class CatsTableViewCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    @IBOutlet var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
