//
//  LaunchViewController.swift
//  Civil World
//
//  Created by Apple on 23/06/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

var profileData:[String:Any] = [:]
var userData:[[String:Any]] = [[:]]
var userEmail = ""

class LaunchViewController: UIViewController {

//MARK: OUTLETS
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
          // ...
            print(user?.email)
            if user != nil {
                userEmail = user?.email ?? ""
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
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    

}

//MARK: ACTIONS
extension LaunchViewController{
    @IBAction func signUpAction(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
