//
//  SignUpViewController.swift
//  Civil World
//
//  Created by Apple on 23/06/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class SignUpViewController: UIViewController {
    
    //MARK: OUTLET
    @IBOutlet weak var teamsAndPolicyLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var featuresTextField: UITextField!
    @IBOutlet weak var talukaTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

//MARK: Actions
extension SignUpViewController {
    @IBAction func logInButtonAction(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        guard let email = emailIDTextField.text, let password = passwordTextField.text else {
            print("Invalid input")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else {
                print("User signed up successfully")
                
                // Reference to Firestore
                let db = Firestore.firestore()

                // Create a "profiles" collection and use the user's email to create a document in that collection
                db.collection("profiles").document(email).setData([
                    "email": email,
                    "createdAt": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        print("Error creating profile document: \(error.localizedDescription)")
                    } else {
                        self.navigationController?.popViewController(animated: true)
                        self.showToast(message: "Signed Up Successfully")
                        print("User profile created successfully with email in 'profiles' collection")
                    }
                }
            }
        }

        
        
        
    }
    
    @IBAction func checkButtonAction(_ sender: Any) {
        
    }
}
