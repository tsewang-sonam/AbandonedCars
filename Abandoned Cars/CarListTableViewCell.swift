//
//  CarListTableViewCell.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 6/11/24.
//

import UIKit

class CarListTableViewCell: UITableViewCell {

    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var content : UILabel!
    @IBOutlet weak var index: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
            img.layer.masksToBounds = true
        // img.layer.contentMode = .aspectFill
        }
    
}
