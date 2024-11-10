//
//  LogInViewController.swift
//  Civil World
//
//  Created by Apple on 23/06/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class LogInViewController: UIViewController {

//MARK: OUTLETS
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var teamsAndPolicyLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

//MARK: ACTIONS
extension LogInViewController{
    
    @IBAction func checkButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func logInButtonAction(_ sender: Any) {
        guard let email = userNameTextField.text, let password = passwordTextField.text else {
            print("Invalid input")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.showAlert(title: "Error signing in", message: "\(error.localizedDescription)", viewController: self)
            } else {
                    print("User signed in successfully")
                    userEmail = email
                    userData = []
                    let db = Firestore.firestore()
                    
                    db.collection("users").getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        } else {
                            for document in querySnapshot!.documents {
                                let data = document.data()
                                userData.append(data)
                                
                            }
                            
                            let docRef = db.collection("profiles").document(userEmail)

                            docRef.getDocument { (document, error) in
                                if let document = document, document.exists {
                                    // The document exists, fetch its data
                                    let data = document.data()
                                    
                                    profileData = data ?? [:]

                                    
                                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                    self.navigationController?.pushViewController(controller, animated: true)
                                    
                                } else {
                                    print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                                }
                            }
                        }
                    }
                }
                

            }
        }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(controller, animated: true)
       
       
    }
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    

}




struct ImageData: Codable {
    let length: Int
    let bytes: Data // Use Data for binary data representation
}

struct Project: Codable {
    let address: String
    let city: String
    let images: [ImageData]
    let profession: String
    let projectDetails: String
    let projectTitle: String
    let state: String
    let status: String
    let taluka: String
    
    enum CodingKeys: String, CodingKey {
        case address
        case city
        case images
        case profession
        case projectDetails = "projectdetails"
        case projectTitle = "projecttitle"
        case state
        case status
        case taluka
    }
}
