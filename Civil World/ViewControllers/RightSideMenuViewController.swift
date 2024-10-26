//
//  SideMenuViewController.swift
//  Civil World
//
//  Created by Apple on 22/06/24.
//

import UIKit
import FirebaseAuth


class RightSideMenuViewController: UIViewController {

    var optionArray = ["HOME", "ADD PR0JECT", "DAILY UPDATE DIARY", "LEADS", "SUBMIT TENDER","VIEW TENDER","FAVORAITES","MY PROFILE","LOGOUT","ABOUT US"]
   // var optionImageArray = [""]
    
//MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var userEmailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameLbl.text = profileData["perSonnelName"] as? String ?? ""
        userEmailLbl.text = profileData["email"] as? String ?? ""
        
    }
}

//MARK: TableView Delegate&Datasource
extension RightSideMenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SidemenuCell", for: indexPath) as! SidemenuCell
        cell.selectionStyle = .none
        
        cell.menuOptionLabel?.text = optionArray[indexPath.row]
       // cell.menuOptionImage?.image = UIImage(named: optionImageArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //for navigation
          
        }
        if indexPath.row == 1 {
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProjectViewController") as! AddProjectViewController
            self.navigationController?.pushViewController(controller, animated: true)
          
        }
        if indexPath.row == 2 {
            
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "DailyViewController") as! DailyViewController
            self.navigationController?.pushViewController(controller, animated: true)
           
        }
        if indexPath.row == 3 {
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "LeadsViewController") as! LeadsViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 4 {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubmitTenderViewController") as! SubmitTenderViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 5 {
//            ViewTenderViewController
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "ViewTenderViewController") as! ViewTenderViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 6 {
           
        }
        if indexPath.row == 7 {
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 8 {
            do {
                        try Auth.auth().signOut()
                        print("User signed out successfully")
                
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
                self.navigationController?.pushViewController(controller, animated: true)
                       
                    } catch let signOutError as NSError {
                        print("Error signing out: \(signOutError.localizedDescription)")
                    }
        }
        if indexPath.row == 9 {
           
        }
    }
    
}
