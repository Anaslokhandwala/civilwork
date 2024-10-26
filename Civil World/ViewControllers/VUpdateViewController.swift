//
//  VUpdateViewController.swift
//  Civil World
//
//  Created by Anas on 12/10/24.
//

import UIKit

class VUpdateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ViewDailyUpdateCell", bundle: nil), forCellReuseIdentifier: "ViewDailyUpdateCell")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension VUpdateViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyupdate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewDailyUpdateCell", for: indexPath) as! ViewDailyUpdateCell
        
        cell.detailsLbl.text = dailyupdate[indexPath.row]["detailtext"] as? String ?? ""
        cell.employeeLbl.text = "Employee Name(Position): \(dailyupdate[indexPath.row]["employeeName"] as? String ?? "")(\(dailyupdate[indexPath.row]["employpos"] as? String ?? ""))"
        cell.titleLbl.text = dailyupdate[indexPath.row]["projectNumber"] as? String ?? ""
            
        
        return cell
    }
    
    
}
