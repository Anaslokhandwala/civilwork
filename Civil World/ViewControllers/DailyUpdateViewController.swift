//
//  DailyUpdateViewController.swift
//  Civil World
//
//  Created by MacBook Pro on 24/07/24.
//

import UIKit
import FirebaseFirestoreInternal

class DailyUpdateViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var detailsTxt: UITextView!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var txfProjectNumber: UITextField!
    @IBOutlet weak var txfEmployeeName: UITextField!
    @IBOutlet weak var txfEmployeePosition: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
        
        if let detailtext = detailsTxt.text,
           let projectNumber = txfProjectNumber.text,
           let employeeName = txfEmployeeName.text,
           let employpos = txfEmployeePosition.text {
            
            let updateData:[String:Any] = [
                projectNumber:
                ["detailtext":detailtext,
                "projectNumber":projectNumber,
                "employeeName":employeeName,
                "employpos":employpos]
            ]
            
            
            
            // Reference to Firestore
            let db = Firestore.firestore()
            
            let docRef = db.collection("dailyUpdate").document(userEmail)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // The document exists, fetch its data
                    let data = document.data() ?? [:]
                    
                    if data.isEmpty {
                        db.collection("dailyUpdate").document(userEmail).setData(updateData) { error in
                            if let error = error {
                                self.showToast(message: "Please Try Again!")
                                print("Error creating profile document: \(error.localizedDescription)")
                            } else {
                                self.showToast(message: "Update Created Successfully")
                                print("User profile created successfully with email in 'profiles' collection")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        db.collection("dailyUpdate").document(userEmail).updateData(updateData) { error in
                            if let error = error {
                                self.showToast(message: "Please Try Again!")
                                print("Error creating profile document: \(error.localizedDescription)")
                            } else {
                                self.showToast(message: "Update Created Successfully")
                                print("User profile created successfully with email in 'profiles' collection")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }else {
                    print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    db.collection("dailyUpdate").document(userEmail).setData(updateData) { error in
                        if let error = error {
                            self.showToast(message: "Please Try Again!")
                            print("Error creating profile document: \(error.localizedDescription)")
                        } else {
                            self.showToast(message: "Update Created Successfully")
                            print("User profile created successfully with email in 'profiles' collection")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            // Create a "profiles" collection and use the user's email to create a document in that collection

            
        }
        
        

        
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
