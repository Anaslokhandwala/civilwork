//
//  LeadsViewController.swift
//  Civil World
//
//  Created by Anas on 13/10/24.
//

import UIKit
import FirebaseFirestoreInternal

var leadsUpdate:[[String:Any]] = []

class LeadsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ViewDailyUpdateCell", bundle: nil), forCellReuseIdentifier: "ViewDailyUpdateCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let db = Firestore.firestore()
        
        
        let docRef = db.collection("queryData").document(userEmail)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // The document exists, fetch its data
                let data = document.data() ?? [:]
                
                print("\(data)")
                leadsUpdate = []

                for (key, value) in data {
                    // Safely cast the value as a dictionary [String: Any]
                    if let dictionary = value as? [String: Any] {
                        leadsUpdate.append(dictionary)
                    } else {
                        print("Value for key \(key) is not of expected type [String: Any]")
                    }
                }
                
//                    let alldata = data.values as? [[String:Any]] ?? [[:]]
                
                if dailyupdate.count > 0 {
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
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
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LeadsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leadsUpdate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDailyUpdateCell", for: indexPath) as! ViewDailyUpdateCell
        
        cell.detailsLbl.text = leadsUpdate[indexPath.row]["enterMessage"] as? String ?? ""
        cell.employeeLbl.text = "Email/Mobile No: \(leadsUpdate[indexPath.row]["enterEmail"] as? String ?? "")/\(leadsUpdate[indexPath.row]["enterPhone"] as? String ?? "")"
        cell.titleLbl.text = "\(leadsUpdate[indexPath.row]["enterName"] as? String ?? "")"
            
        
        return cell
    }
    
    
}
