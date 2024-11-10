//
//  PhotosPickerCell.swift
//  Civil World
//
//  Created by MacBook Pro on 08/07/24.
//

import UIKit

class PhotosPickerCell: UICollectionViewCell {

    @IBOutlet weak var imgPick: UIImageView!
    
    var imageii:UIImage?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgPick.image = imageii
        // Initialization code
    }

}
