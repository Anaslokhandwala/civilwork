//
//  HomeListingCell.swift
//  Civil World
//
//  Created by Apple on 22/06/24.
//

import UIKit

class HomeListingCell: UITableViewCell {
    
    
//MARK: OUTLETS
    @IBOutlet weak var talukaLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var statusLbl: UIButton!
    @IBOutlet weak var projectDetails: UILabel!
    @IBOutlet weak var statusTxtLbl: UILabel!
    
    var navigationController: UINavigationController?
    var arrImage = [UIImage(named: "Image1"),UIImage(named: "Image"),UIImage(named: "Image2"),UIImage(named: "Image3")]
    var imageArr = [Data]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
//        if imageArr.count > 0 {
//            arrImage = []
//            for i in imageArr {
//                if let image = UIImage(data: i) {
//                    arrImage.append(image)
//                }else{
//                    arrImage.append(UIImage(named: "Image1"))
//                }
//            }
//        }
        
    }

    @IBAction func statusBtn(_ sender: UIButton) {

    }
}

//MARK: Collection View Delegate&Datasource
extension HomeListingCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailListingCell", for: indexPath) as! HomeDetailListingCell
        cell.ic_Image.image = arrImage[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20 , height: self.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
    }
}
