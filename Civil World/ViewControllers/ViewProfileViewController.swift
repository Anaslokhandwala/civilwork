//
//  ViewProfileViewController.swift
//  Civil World
//
//  Created by MacBook Pro on 19/07/24.
//

import UIKit
import FirebaseFirestoreInternal

var userprojectData:[[String:Any]] = [[:]]

class ViewProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblWorkingField: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnEditProfile: UIButton!
    
    var isView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isView {
            btnEditProfile.isHidden = true
        }else{
            btnEditProfile.isHidden = false
        }
        
        tableView.reloadData()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lblCompanyName.text = profileData["comPanyName"] as? String ?? ""
        lblOwnerName.text = profileData["perSonnelName"] as? String ?? ""
        lblWorkingField.text = profileData["specialities"] as? String ?? ""
        if let imageData = profileData["profileImage"] as? Data {
            if let image = UIImage(data: imageData) {
                imgProfile.image = image
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "postCell", bundle: nil), forCellReuseIdentifier: "postCell")
        topView.layer.cornerRadius = 10
        btnEditProfile.layer.cornerRadius = 10
        
        
        let db = Firestore.firestore()

        let projectsRef = db.collection("profiles").document(userEmail).collection("projects")

        projectsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching projects: \(error.localizedDescription)")
            } else {
                userprojectData = []
                for document in querySnapshot!.documents {
                    let projectData = document.data()
                    userprojectData.append(projectData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editBtnClicked(_ sender: UIButton) {
        let rowIndex = sender.tag
        print("Edit button clicked for row: \(rowIndex)")
        // Perform edit action for the corresponding row using the rowIndex
        let projectData = userprojectData[rowIndex]
        
        let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "EditProjectViewController") as! EditProjectViewController
        
        controller.rowIndex = rowIndex
        controller.projectData = projectData
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        // Add your edit logic here
    }

    @objc func deleteBtnClicked(_ sender: UIButton) {
        let rowIndex = sender.tag
        print("Delete button clicked for row: \(rowIndex)")
        // Perform delete action for the corresponding row using the rowIndex
        let projectData = userprojectData[rowIndex]
        print(projectData)
        let project_ID = "\(projectData["projecttitle"] ?? "")_\(userEmail)_\(projectData["city"] ?? "")"
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("profiles").document(userEmail).collection("projects").document(project_ID)

        // Delete the project document
        docRef.delete { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showToast(message: "Please try again!")
                }
                print("Error deleting project: \(error.localizedDescription)")
            } else {
                
                let docRef = db.collection("users").document(projectData["projecttitle"] as? String ?? "")

                // Delete the document using titleText as the document ID
                docRef.delete { error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.showToast(message: "Please try again!")
                        }
                        print("Error deleting document: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            userprojectData.remove(at: rowIndex)
                            self.showToast(message: "Project Deleted Successfully")
                            self.tableView.reloadData()
                        }
                        print("Project successfully deleted!")
                    }
                }
            }
        }
    }


}

extension ViewProfileViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userprojectData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! postCell
        
        let vari = userprojectData[indexPath.row]["images"] as? [Data] ?? []
        var imageArr: UIImage?
        if vari.count > 0 {
            imageArr = UIImage(data: vari[0])
            cell.imgProject.image = imageArr
        }
        cell.isView = isView
        cell.lblProjectName.text = userprojectData[indexPath.row]["projecttitle"] as? String ?? ""
        cell.lblStatus.text = userprojectData[indexPath.row]["status"] as? String ?? ""

        // Set the tag to identify the row
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row

        // Add target to the buttons
        cell.editBtn.addTarget(self, action: #selector(editBtnClicked(_:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       100
    }
    
    
}
