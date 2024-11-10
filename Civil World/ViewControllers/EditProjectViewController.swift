//
//  EditProjectViewController.swift
//  Civil World
//
//  Created by Anas on 13/10/24.
//

import UIKit
import iOSDropDown
import PhotosUI
import FirebaseFirestoreInternal

class EditProjectViewController: UIViewController, UITextFieldDelegate,PHPickerViewControllerDelegate {

    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var projectDetails: UITextView!
    @IBOutlet weak var TxfProfession: DropDown!
    @IBOutlet weak var txfStatus: DropDown!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var talukaTF: UITextField!
    @IBOutlet weak var zipCadeTF: UITextField!
    @IBOutlet weak var txfView: UIView!
    @IBOutlet weak var btnAddPhotos: UIButton!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let  dropDown = DropDown(frame: CGRect(x: 110, y: 140, width: 200, height: 30))
    var imageArr = [UIImage]()
    var rowIndex = 0
    var projectData:[String:Any] = [:]
    var oldTitleText = ""
    var oldcustomID = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()

        txfView.layer.cornerRadius = 5
        txfView.layer.borderWidth = 1
        txfView.layer.borderColor = UIColor.lightGray.cgColor
        
        photoView.layer.cornerRadius = 5
        photoView.layer.borderWidth = 1
        photoView.layer.borderColor = UIColor.lightGray.cgColor
        
        dropDown.delegate = self
        
        collectionView.register(UINib(nibName: "PhotosPickerCell", bundle: nil), forCellWithReuseIdentifier: "PhotosPickerCell")
        
        //   TxfProfession.optionArray = ["Option 1", "Option 2", "Option 3"]
        //Its Id Values and its optional
        //  TxfProfession.optionIds = [1,23,54]
        TxfProfession.optionArray = ["Civil engineer","Architect engineer","Interior design","Consulting engineer","Building materials","Plumbing contractor","Electrician contractor","Painter contractor","Fabrication contractor","Excavation (machine)","Excavation (worker)","Slab casing team","Parking blocks / tiles","Bricks","Road, bridge contractor","Road, bridge contractor","Crusher","Property for sell","Labour Thekedar"]
        //  TxfProfession.selectedRowColor = UIColor.black
        
        txfStatus.optionArray = ["Completed","Ongoing","Upcoming"]

        // Do any additional setup after loading the view.
        collectionView.isHidden = true
        
        
        projectTitle.text = projectData["projecttitle"] as? String
        projectDetails.text = projectData["projectdetails"] as? String
        TxfProfession.text = projectData["profession"] as? String
        txfStatus.text = projectData["status"] as? String
        addressTF.text = projectData["address"] as? String
        stateTF.text = projectData["state"] as? String
        cityTF.text = projectData["city"] as? String
        talukaTF.text = projectData["taluka"] as? String
        
        oldTitleText = projectData["projecttitle"] as? String ?? ""
        oldcustomID = "\(projectData["projecttitle"] as? String ?? "")_\(userEmail)_\(projectData["city"] as? String ?? "")"
        
        
        let vari = projectData["images"] as? [Data] ?? []
//        var imageArr = [UIImage]()
        if vari.count > 0 {
            for i in vari {
                if let image = UIImage(data: i) {
                    imageArr.append(image)
                }
            }
            collectionView.reloadData()
        }
        
        
        
        if imageArr.count != 0 {
            btnAddPhotos.isHidden = true
            imageArr.append(UIImage(named: "imagePicker")!)
        }
        else {
            btnAddPhotos.isHidden = false
        }
        
        collectionView.layer.borderWidth = 1
        
        
    }
    
    @IBAction func btnAddPhotos(_ sender: Any) {
        
        imageArr.removeAll()
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }

    @IBAction func backBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    func compressImageToTargetSize(image: UIImage, targetSizeInKB: Int) -> Data? {
        let targetFileSize = targetSizeInKB * 1024
        var compressionQuality: CGFloat = 1.0
        var imageData = image.jpegData(compressionQuality: compressionQuality)
        
        // Reduce the compression quality iteratively until the file size is less than the target size
        while let data = imageData, data.count > targetFileSize, compressionQuality > 0.01 {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }
        
        return imageData
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        
        
//        imageArr.removeAll()
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.imageArr.append(image)
                    }
                    
                    self?.collectionView.isHidden = false
                    self?.collectionView.reloadData()
                }
                
            }
        }
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
        
        if let titleText = projectTitle.text,
           let detailText = projectDetails.text,
           let selectedProfession = TxfProfession.text,
           let State = stateTF.text,
           let address = addressTF.text,
           let city = cityTF.text,
           let taluka = talukaTF.text,
           let selectedStatus = txfStatus.text {
            
            let db = Firestore.firestore()
            
            if !imageArr.isEmpty{
                // Print the values
                print("Title: \(titleText)")
                print("Detail: \(detailText)")
                print("Selected Profession: \(selectedProfession)")
                print("Selected Status: \(selectedStatus)")
                
                var imageData = [Data]()
                
                for image in imageArr {
                    imageData.append(self.compressImageToTargetSize(image: image, targetSizeInKB: 50)!)
                }
                
                let userData: [String: Any] =
                ["projecttitle": titleText,
                 "projectdetails": detailText,
                 "address": address,
                 "state": State,
                 "city": city,
                 "taluka":taluka,
                 "profession":selectedProfession,
                 "status":selectedStatus,
                 "images":imageData
                ]
                
                
                db.collection("users").document(oldTitleText).getDocument { (document, error) in
                    if let document = document, document.exists {
                        // Set the new document with the old data plus any updates
                        db.collection("users").document(titleText).setData(userData) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                // Optionally, delete the old document
                                db.collection("users").document(self.oldTitleText).delete() { error in
                                    if let error = error {
                                        print("Error removing old document: \(error)")
                                    } else {
                                        print("Old document successfully deleted!")
                                    }
                                }
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
                

                db.collection("users").document(titleText).setData(userData) { error in
                    if let error = error {
                        print("Error updating Firestore document: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.showToast(message: "Image size too big!")
                        }
                        
                    } else {
                        
                        db.collection("users").document(self.oldTitleText).delete() { error in
                            if let error = error {
                                print("Error removing old document: \(error)")
                            } else {
                                print("Old document successfully deleted!")
                            }
                        }
                        
                        print("Firestore document updated successfully!")

                        let customID = "\(titleText)_\(userEmail)_\(city)"
                        
                        db.collection("profiles")
                          .document(userEmail)
                          .collection("projects")
                          .document(self.oldcustomID) // Using the custom ID here
                          .delete(){ error in
                              if let error = error {
                                  print("Error removing old document: \(error)")
                              } else {
                                  print("Old document successfully deleted!")
                              }
                          }
                        
                        db.collection("profiles")
                          .document(userEmail)
                          .collection("projects")
                          .document(customID) // Using the custom ID here
                          .setData(userData) { error in
                              if let error = error {
                                  DispatchQueue.main.async {
                                      self.showToast(message: "Image size too big!")
                                  }
                                  print("Error adding project: \(error.localizedDescription)")
                              } else {
                                  DispatchQueue.main.async {
                                      self.showToast(message: "Project Updated successfully!")
                                  }
                                  print("Project Updated successfully")
                                  self.navigationController?.popViewController(animated: true)
                              }
                          }

                        
                        

                    }
                }
                
//                self.addUserProjectData(userId: emailID, data: userData, imageArr: self.imageArr)
                // Do something with the values
                if titleText.isEmpty {
                    print("Title field is empty")
                } else {
                    // Further processing
                }
            }
        } else {
            print("Some fields are empty or not properly initialized.")
        }
        
        

    }
    

}

extension EditProjectViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosPickerCell", for: indexPath) as! PhotosPickerCell
        
        cell.imgPick.layer.borderWidth = 1
        
        if let image = imageArr[indexPath.row] as? UIImage {
            cell.imageii = image

        }
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding
        let itemSize = collectionViewSize / 2 // Three columns with spacing

        return CGSize(width: itemSize, height: 120.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == imageArr.count - 1 {
            
            imageArr.removeAll()
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 10
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
    
    
}
