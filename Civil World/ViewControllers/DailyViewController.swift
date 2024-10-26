//
//  DairyViewController.swift
//  Civil World
//
//  Created by Anas on 12/10/24.
//

import UIKit
import FirebaseFirestoreInternal

var dailyupdate:[[String:Any]] = [[:]]

class DailyViewController: UIViewController {

    @IBOutlet weak var viewDaily: UIView!
    @IBOutlet weak var addView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewDaily.layer.cornerRadius = 15.0
        addView.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addDairyBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "DailyUpdateViewController") as! DailyUpdateViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func viewDairyBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            let db = Firestore.firestore()
            
            let docRef = db.collection("dailyUpdate").document(userEmail)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // The document exists, fetch its data
                    let data = document.data() ?? [:]
                    
                    print("\(data)")
                    dailyupdate = []

                    for (key, value) in data {
                        // Safely cast the value as a dictionary [String: Any]
                        if let dictionary = value as? [String: Any] {
                            dailyupdate.append(dictionary)
                        } else {
                            print("Value for key \(key) is not of expected type [String: Any]")
                        }
                    }
                    
//                    let alldata = data.values as? [[String:Any]] ?? [[:]]
                    
                    if dailyupdate.count > 0 {
                        
//                        dailyupdate = alldata
                        let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "VUpdateViewController") as! VUpdateViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                        
                    }else{
                        //Alert
                        DispatchQueue.main.async {
                            self.showToast(message: "No Update Found")
                        }
                    }
                    
//                    print(alldata)

                } else {
                    print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        self.showToast(message: "No Update Found")
                    }
                }
            }
            

        }
    }


}
