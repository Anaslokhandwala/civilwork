//
//  ProfileViewController.swift
//  Civil World
//
//  Created by Deepak Rawat on 15/07/24.
//

import UIKit
import FirebaseFirestoreInternal
import PhotosUI


var userProfileImage:UIImage?

class ProfileViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var AboutMe: UITextView!
    @IBOutlet weak var specialities: UITextField!
    @IBOutlet weak var serviceAreas: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var taxNumber: UITextField!
    @IBOutlet weak var whatsAppNumber: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var licenseF: UITextField!
    @IBOutlet weak var companyServices: UITextField!
    @IBOutlet weak var perSonnelName: UITextField!
    @IBOutlet weak var comPanyName: UITextField!
    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var topNameLabel: UILabel!
    
    var profileImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataBinding()
        
        // Do any additional setup after loading the view.
    }
    
    
    func dataBinding()
    {
        topNameLabel.text = profileData["perSonnelName"] as? String ?? ""
        
        licenseF.text = profileData["licenseF"] as? String ?? ""
        AboutMe.text = profileData["AboutMe"] as? String ?? ""
        specialities.text = profileData["specialities"] as? String ?? ""
        serviceAreas.text = profileData["serviceAreas"] as? String ?? ""
        address.text = profileData["address"] as? String ?? ""
        phoneNumber.text = profileData["phoneNumber"] as? String ?? ""
        taxNumber.text = profileData["taxNumber"] as? String ?? ""
        whatsAppNumber.text = profileData["whatsAppNumber"] as? String ?? ""
        mobileNumber.text = profileData["mobileNumber"] as? String ?? ""
        companyServices.text = profileData["companyServices"] as? String ?? ""
        perSonnelName.text = profileData["perSonnelName"] as? String ?? ""
        comPanyName.text = profileData["comPanyName"] as? String ?? ""
        emailID.text = profileData["email"] as? String ?? ""
        userName.text = profileData["userName"] as? String ?? ""
        
        if let imageData = profileData["profileImage"] as? Data {
            if let image = UIImage(data: imageData) {
                profileImg.image = image
                profileImage = image
                userProfileImage = image
            }
        }
    }
    
   
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func updateProfile(_ sender: UIButton) {
        
        self.updateData()
        
    }
    
    func updateData() {
        
        let AboutMe = AboutMe.text ?? ""
        let specialities = specialities.text ?? ""
        let serviceAreas = serviceAreas.text ?? ""
        let address = address.text ?? ""
        let phoneNumber = phoneNumber.text ?? ""
        let taxNumber = taxNumber.text ?? ""
        let whatsAppNumber = whatsAppNumber.text ?? ""
        let mobileNumber = mobileNumber.text ?? ""
        
        let licenseF = licenseF.text ?? ""
        let companyServices = companyServices.text ?? ""
        let perSonnelName = perSonnelName.text ?? ""
        let comPanyName = comPanyName.text ?? ""
        let emailID = emailID.text ?? ""
        let userName = userName.text ?? ""
        
        
        var userData: [String: Any] =
        ["AboutMe": AboutMe,
         "specialities": specialities,
         "serviceAreas": serviceAreas,
         "address": address,
         "phoneNumber": phoneNumber,
         "taxNumber":taxNumber,
         "whatsAppNumber":whatsAppNumber,
         "mobileNumber":mobileNumber,
         "licenseF":licenseF,
         "companyServices": companyServices,
         "perSonnelName":perSonnelName,
         "comPanyName":comPanyName,
         "email":emailID,
         "userName":userName
        ]
        
        if let image = profileImage {
            // Image is present, and you can use 'image' here
            print("Image is available.")
            
            let datImage = compressImageToTargetSize(image: image, targetSizeInKB: 50)
            
            userData["profileImage"] = datImage
            
        } else {
            // No image is set
            print("No image in profileImage.")
        }
        
        let db = Firestore.firestore()
        db.collection("profiles").document(userEmail).setData(userData) { error in
            if let error = error {
                print("Error updating Firestore document: \(error.localizedDescription)")
            } else {
                
                profileData = userData
                print("Firestore document updated successfully!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func profileImageButton(_ sender: UIButton) {
        pickImage()
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
    
     func pickImage() {
           let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
           
           alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
               self.openCamera()
           }))
           
           alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
               self.openGallery()
           }))
           
           alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
           
           // For iPad: This is necessary to prevent a crash
           if let popoverController = alert.popoverPresentationController {
               popoverController.sourceView = self.view
               popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
               popoverController.permittedArrowDirections = []
           }
           
           self.present(alert, animated: true, completion: nil)
       }
       
       func openCamera() {
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = .camera
               imagePicker.allowsEditing = true
               self.present(imagePicker, animated: true, completion: nil)
           } else {
               let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
       
       func openGallery() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = true
           self.present(imagePicker, animated: true, completion: nil)
       }
       
       // MARK: - UIImagePickerControllerDelegate Methods
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           
           if let editedImage = info[.editedImage] as? UIImage {
               profileImage = editedImage
               profileImg.image = editedImage
               userProfileImage = editedImage
               // Use edited image
               // Do something with the image (e.g., set it to an UIImageView)
           } else if let originalImage = info[.originalImage] as? UIImage {
               // Use original image
               // Do something with the image (e.g., set it to an UIImageView)
               profileImage = originalImage
               profileImg.image = originalImage
               userProfileImage = originalImage
           }
//           self.updateData()
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
   }
   
    

