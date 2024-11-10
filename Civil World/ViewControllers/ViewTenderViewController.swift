//
//  ViewTenderViewController.swift
//  Civil World
//
//  Created by Anas on 13/10/24.
//

import UIKit
import FirebaseFirestoreInternal

var tenderDat:[[String:Any]] = []

class ViewTenderViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ViewDailyUpdateCell", bundle: nil), forCellReuseIdentifier: "ViewDailyUpdateCell")
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let db = Firestore.firestore()
        
        
        let docRef = db.collection("tenderData").document(userEmail)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // The document exists, fetch its data
                let data = document.data() ?? [:]
                
                print("\(data)")
                tenderDat = []

                for (key, value) in data {
                    // Safely cast the value as a dictionary [String: Any]
                    if let dictionary = value as? [String: Any] {
                        tenderDat.append(dictionary)
                    } else {
                        print("Value for key \(key) is not of expected type [String: Any]")
                    }
                }
                
//                    let alldata = data.values as? [[String:Any]] ?? [[:]]
                
                if tenderDat.count > 0 {
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }else{
                    //Alert
                    DispatchQueue.main.async {
                        self.showToast(message: "No Tender Found")
                    }
                }
                
//                    print(alldata)

            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.showToast(message: "No Tender Found")
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

}

extension ViewTenderViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tenderDat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDailyUpdateCell", for: indexPath) as! ViewDailyUpdateCell
        
        cell.detailsLbl.text = tenderDat[indexPath.row]["tenderDescription"] as? String ?? ""
        cell.employeeLbl.text = "Email/Mobile No: \(tenderDat[indexPath.row]["email"] as? String ?? "")/\(tenderDat[indexPath.row]["number"] as? String ?? "")"
        cell.titleLbl.text = "\(tenderDat[indexPath.row]["tenderTitle"] as? String ?? "")"
            
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        SubmitTenderViewController
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubmitTenderViewController") as! SubmitTenderViewController
        controller.detailsOfContr = tenderDat[indexPath.row]
        controller.isEditingEn = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
