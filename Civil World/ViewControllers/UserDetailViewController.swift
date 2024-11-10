//
//  UserDetailViewController.swift
//  Civil World
//
//  Created by Deepak Rawat on 15/07/24.
//

import UIKit
import FirebaseFirestoreInternal

class UserDetailViewController: UIViewController {

    var userDetail = ""
    var statusBtn = ""
    var descriptiontxt = ""
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var contactProfileImage: UIImageView!
    @IBOutlet weak var contactnameLbl: UILabel!
    @IBOutlet weak var phoneNoLbl: UILabel!
    @IBOutlet weak var enquireLbl: UILabel!
    @IBOutlet weak var enterNameTextfield: UITextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var enterPhoneTextfield: UITextField!
    @IBOutlet weak var enterEmailTextfield: UITextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var enterMessageTextfield: UITextView!
    @IBOutlet weak var requestInformationButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var arrImage = [UIImage(named: "Image1"),UIImage(named: "Image"),UIImage(named: "Image2"),UIImage(named: "Image3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLbl.text = userDetail
//        statusButton.titleLabel?.text = statusBtn
        statusLbl.text = statusBtn
        descriptionTextView.text = descriptiontxt
        phoneNoLbl.text = profileData["mobileNumber"] as? String ?? ""
        contactnameLbl.text = profileData["perSonnelName"] as? String ?? ""
        contactProfileImage.image = userProfileImage
    }
    @IBAction func requestInformationAction(_ sender: Any) {
        
        if let enterName = enterNameTextfield.text,
           let enterPhone = enterPhoneTextfield.text,
           let enterMessage = enterMessageTextfield.text,
           let enterEmail = enterEmailTextfield.text {
            
            
            let queryData:[String:Any] = ["\(enterPhone)/\(enterEmail)":[
                "enterName":enterName,
                "enterPhone":enterPhone,
                "enterMessage":enterMessage,
                "enterEmail":enterEmail
            ]]
            
            let db = Firestore.firestore()

            let docRef = db.collection("queryData").document(userEmail)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // The document exists, fetch its data
                    let data = document.data() ?? [:]
                    
                    if data.isEmpty {
                        db.collection("queryData").document(userEmail).setData(queryData) { error in
                            if let error = error {
                                self.showToast(message: "Please Try Again!")
                                print("Error creating profile document: \(error.localizedDescription)")
                            } else {
                                self.showToast(message: "Query Created Successfully")
                                print("User profile created successfully with email in 'profiles' collection")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        db.collection("queryData").document(userEmail).updateData(queryData) { error in
                            if let error = error {
                                self.showToast(message: "Please Try Again!")
                                print("Error creating profile document: \(error.localizedDescription)")
                            } else {
                                self.showToast(message: "Query Created Successfully")
                                print("User profile created successfully with email in 'profiles' collection")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }else {
                    print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    db.collection("queryData").document(userEmail).setData(queryData) { error in
                        if let error = error {
                            self.showToast(message: "Please Try Again!")
                            print("Error creating profile document: \(error.localizedDescription)")
                        } else {
                            self.showToast(message: "Query Created Successfully")
                            print("User profile created successfully with email in 'profiles' collection")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            
        }
        
    }
    @IBAction func sendMessageAction(_ sender: Any) {
    }
    @IBAction func backButtonAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    }
    
}
extension UserDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userImageCollectionViewCell", for: indexPath) as! userImageCollectionViewCell
        cell.ic_Image.image = arrImage[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
    }
  
}


