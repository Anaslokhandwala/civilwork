//
//  SidemenuCell.swift
//  Civil World
//
//  Created by Apple on 22/06/24.
//

import UIKit

class SidemenuCell: UITableViewCell {

//MARK: OUTLETS
    @IBOutlet weak var menuOptionLabel: UILabel!
    @IBOutlet weak var menuOptionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}
