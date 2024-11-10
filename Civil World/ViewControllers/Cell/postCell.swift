//
//  postCell.swift
//  Civil World
//
//  Created by MacBook Pro on 19/07/24.
//

import UIKit

class postCell: UITableViewCell {

    @IBOutlet weak var imgProject: UIImageView!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var image:UIImage?
    var isView = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.editBtn.layer.cornerRadius = 10
        self.editBtn.layer.borderWidth = 1
        
        self.deleteBtn.layer.cornerRadius = 10
        self.deleteBtn.layer.borderWidth = 1
        
        if viewForCell {
            editBtn.isHidden = true
            deleteBtn.isHidden = true
        }else{
            editBtn.isHidden = false
            deleteBtn.isHidden = false
        }

        
//        if let img = image {
//            imgProject.image = img
//        }else{
//            imgProject.image = UIImage(named: "Mask Group 7")
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        
    }
}
