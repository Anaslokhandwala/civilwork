//
//  HomeListingCell.swift
//  Civil World
//
//  Created by Apple on 22/06/24.
//

protocol HomeListingCellDelegate: AnyObject {
    func didSelectItem(at indexPath: IndexPath, projTitle: String, proSts: String, projDet: String, images: [UIImage]?)
}

import UIKit

class HomeListingCell: UITableViewCell {
    
    
//MARK: OUTLETS
    @IBOutlet weak var talukaLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var statusLbl: UIButton!
    @IBOutlet weak var projectDetails: UILabel!
    @IBOutlet weak var statusTxtLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    weak var delegate: HomeListingCellDelegate?
    var projTitle = ""
    var proSts = ""
    var projDet = ""
    var images:[UIImage]?
    
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
    
    @IBAction func shareBtn(_ sender: UIButton) {
        let textToShare = projectDetails.text ?? ""
        let imageToShare = images?[0]// Replace with your image if needed
        let urlToShare = URL(string: "https://example.com") // Optional URL to share
        
        // Create an array of the items you want to share
        var itemsToShare: [Any] = [textToShare]
        if let image = imageToShare {
            itemsToShare.append(image)
        }
        if let url = urlToShare {
            itemsToShare.append(url)
        }
        
        // Initialize UIActivityViewController with the items
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        // Exclude any activity types you don’t want to display (optional)
//        activityViewController.excludedActivityTypes = [
//            .postToFacebook,
//            .postToTwitter,
//            .postToWeibo,
//            .message,
//            .mail
//        ]
        
        // Present the activity view controller
        if let viewController = self.window?.rootViewController {
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }

    @IBAction func statusBtn(_ sender: UIButton) {

    }
}

//MARK: Collection View Delegate&Datasource
extension HomeListingCell:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailListingCell", for: indexPath) as! HomeDetailListingCell
        cell.ic_Image.image = arrImage[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: self.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didSelectItem(at: indexPath, projTitle: projTitle, proSts: proSts, projDet: projDet, images: images)
        
    }

}
