//
//  SubmitTenderViewController.swift
//  Civil World
//
//  Created by Deepak Rawat on 15/07/24.
//

import UIKit
import FirebaseFirestoreInternal

class SubmitTenderViewController: UIViewController {

    @IBOutlet weak var tenderTitleTF: UITextField!
    
    @IBOutlet weak var tenderDiscriptionTF: UITextView!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var lattitudeTF: UITextField!
    @IBOutlet weak var diningroomTF: UITextField!
    @IBOutlet weak var outdoorSeatingTF: UITextField!
    @IBOutlet weak var gameroomTF: UITextField!
    @IBOutlet weak var guestroomTF: UITextField!
    @IBOutlet weak var studyTF: UITextField!
    @IBOutlet weak var gymTF: UITextField!
    @IBOutlet weak var bathroomTF: UITextField!
    @IBOutlet weak var bedroomTF: UITextField!
    @IBOutlet weak var kitchenTF: UITextField!
    @IBOutlet weak var hallTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var talukaTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var neCoorRenTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitTenderBtn(_ sender: UIButton) {
        
        if let tenderTitle = tenderTitleTF.text, !tenderTitle.isEmpty,
           let tenderDescription = tenderDiscriptionTF.text, !tenderDescription.isEmpty,
           let longitude = longitudeTF.text, !longitude.isEmpty,
           let latitude = lattitudeTF.text, !latitude.isEmpty,
           let diningRoom = diningroomTF.text, !diningRoom.isEmpty,
           let outdoorSeating = outdoorSeatingTF.text, !outdoorSeating.isEmpty,
           let gameRoom = gameroomTF.text, !gameRoom.isEmpty,
           let guestRoom = guestroomTF.text, !guestRoom.isEmpty,
           let study = studyTF.text, !study.isEmpty,
           let gym = gymTF.text, !gym.isEmpty,
           let bathroom = bathroomTF.text, !bathroom.isEmpty,
           let bedroom = bedroomTF.text, !bedroom.isEmpty,
           let kitchen = kitchenTF.text, !kitchen.isEmpty,
           let hall = hallTF.text, !hall.isEmpty,
           let address = addressTF.text, !address.isEmpty,
           let taluka = talukaTF.text, !taluka.isEmpty,
           let number = numberTF.text, !number.isEmpty,
           let email = emailTF.text, !email.isEmpty,
           let neCoorRenTF = neCoorRenTF.text, !neCoorRenTF.isEmpty,
           let name = nameTF.text, !name.isEmpty {

            let tenderData: [String: Any] = ["\(tenderTitle)_\(email)_\(name)":[
                "tenderTitle": tenderTitle.replacingOccurrences(of: "/", with: "_"),
                "tenderDescription": tenderDescription.replacingOccurrences(of: "/", with: "_"),
                "longitude": longitude.replacingOccurrences(of: "/", with: "_"),
                "latitude": latitude.replacingOccurrences(of: "/", with: "_"),
                "diningRoom": diningRoom.replacingOccurrences(of: "/", with: "_"),
                "outdoorSeating": outdoorSeating.replacingOccurrences(of: "/", with: "_"),
                "gameRoom": gameRoom.replacingOccurrences(of: "/", with: "_"),
                "guestRoom": guestRoom.replacingOccurrences(of: "/", with: "_"),
                "study": study.replacingOccurrences(of: "/", with: "_"),
                "gym": gym.replacingOccurrences(of: "/", with: "_"),
                "bathroom": bathroom.replacingOccurrences(of: "/", with: "_"),
                "bedroom": bedroom.replacingOccurrences(of: "/", with: "_"),
                "kitchen": kitchen.replacingOccurrences(of: "/", with: "_"),
                "hall": hall.replacingOccurrences(of: "/", with: "_"),
                "address": address.replacingOccurrences(of: "/", with: "_"),
                "taluka": taluka.replacingOccurrences(of: "/", with: "_"),
                "number": number.replacingOccurrences(of: "/", with: "_"),
                "email": email.replacingOccurrences(of: "/", with: "_"),
                "name": name.replacingOccurrences(of: "/", with: "_"),
                "neCoorRenTF":neCoorRenTF.replacingOccurrences(of: "/", with: "_")
            ]]
            
            let db = Firestore.firestore()

            let docRef = db.collection("tenderData").document(userEmail)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // The document exists, fetch its data
                    let data = document.data() ?? [:]
                    
                    if data.isEmpty {
                        db.collection("tenderData").document(userEmail).setData(tenderData) { error in
                            if let error = error {
                                self.showToast(message: "Please Try Again!")
                                print("Error creating profile document: \(error.localizedDescription)")
                            } else {
                                self.showToast(message: "Tender Created Successfully")
                                print("User profile created successfully with email in 'profiles' collection")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        db.collection("tenderData").document(userEmail).updateData(tenderData) { error in
                            if let error = error {
                                self.showToast(message: "Please Try Again!")
                                print("Error creating profile document: \(error.localizedDescription)")
                            } else {
                                self.showToast(message: "Tender Created Successfully")
                                print("User profile created successfully with email in 'profiles' collection")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }else {
                    print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    db.collection("tenderData").document(userEmail).setData(tenderData) { error in
                        if let error = error {
                            self.showToast(message: "Please Try Again!")
                            print("Error creating profile document: \(error.localizedDescription)")
                        } else {
                            self.showToast(message: "Tender Created Successfully")
                            print("User profile created successfully with email in 'profiles' collection")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            
            
            
            
            
        } else {
            // Handle the case where any field is empty
            print("Please fill out all fields")
        }
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    }
}
