//
//  ProfileViewController.swift
//  Civil World
//
//  Created by Deepak Rawat on 15/07/24.
//

import UIKit
import FirebaseFirestoreInternal

class ProfileViewController: UIViewController, UITextFieldDelegate {

    
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
    
    @IBOutlet weak var topNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func updateProfile(_ sender: UIButton) {
        
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
        
        
        let userData: [String: Any] =
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
    
}
