//
//  FavouriteViewController.swift
//  Civil World
//
//  Created by Anas on 10/11/24.
//

import UIKit
import FirebaseFirestoreInternal

class FavouriteViewController:  UIViewController, HomeListingCellDelegate {
    
    //MARK: OUTLETS
        @IBOutlet weak var tableView: UITableView!
        
        var sideMenuViewController: RightSideMenuViewController!
           var sideMenuWidth: CGFloat = 250
           var isSideMenuOpen: Bool = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupSideMenu()
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            DispatchQueue.main.async {
                let db = Firestore.firestore()
                
                db.collection("users").getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        userData = []
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            userData.append(data)
                            
                        }
                        self.tableView.reloadData()
                    }
                }
            }

        }
        
        func setupSideMenu() {
             sideMenuViewController = storyboard?.instantiateViewController(withIdentifier: "RightSideMenuViewController") as? RightSideMenuViewController
             addChild(sideMenuViewController)
             view.addSubview(sideMenuViewController.view)
             sideMenuViewController.didMove(toParent: self)
             
             // Set initial frame off-screen
             sideMenuViewController.view.frame = CGRect(x: view.frame.width, y: 0, width: sideMenuWidth, height: view.frame.height)
             
             // Add swipe gesture recognizer
             let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
             swipeLeft.direction = .left
             view.addGestureRecognizer(swipeLeft)
             
             let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
             swipeRight.direction = .right
             view.addGestureRecognizer(swipeRight)
         }
         
         @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
             if gesture.direction == .right {
                 closeSideMenu()
             } else if gesture.direction == .left {
                 openSideMenu()
             }
         }
         
         func toggleSideMenu() {
             isSideMenuOpen ? closeSideMenu() : openSideMenu()
         }
         
         func openSideMenu() {
             UIView.animate(withDuration: 0.3) {
                 self.sideMenuViewController.view.frame.origin.x = self.view.frame.width - self.sideMenuWidth
             }
             isSideMenuOpen = true
         }
         
         func closeSideMenu() {
             UIView.animate(withDuration: 0.3) {
                 self.sideMenuViewController.view.frame.origin.x = self.view.frame.width
             }
             isSideMenuOpen = false
         }
        
        func didSelectItem(at indexPath: IndexPath, projTitle: String, proSts: String, projDet: String, images: [UIImage]?) {
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else {
                print("Could not instantiate UserDetailViewController")
                return
            }

            controller.userDetail = projTitle
            controller.statusBtn = proSts
            controller.descriptiontxt = projDet

            if let images = images {
                controller.arrImage = images
            }

            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
     }
        


    //MARK: ACTIONS
    extension FavouriteViewController{
        @IBAction func sideMenuAction(_ sender: UIButton) {
            toggleSideMenu()
        }
    }

    //MARK: TableView Delegate&Datasource
    extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            userData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeListingCell") as! HomeListingCell
            cell.delegate = self
            let vari = userData[indexPath.row]["images"] as? [Data] ?? []
            var imageArr = [UIImage]()
            if vari.count > 0 {
                for i in vari {
                    if let image = UIImage(data: i) {
                        imageArr.append(image)
                    }
                }
            }
            cell.arrImage = imageArr
    //        cell.imageArr = userData[indexPath.row]["images"] as? [Data] ?? []
            cell.talukaLbl.text = userData[indexPath.row]["taluka"] as? String ?? ""
    //        print(userData[indexPath.row]["status"])
            cell.statusTxtLbl.text = userData[indexPath.row]["status"] as? String ?? ""
            cell.projectDetails.text = userData[indexPath.row]["projecttitle"] as? String ?? ""

            cell.projDet = userData[indexPath.row]["projectdetails"] as? String ?? ""
            cell.proSts = userData[indexPath.row]["status"] as? String ?? ""
            cell.projTitle = userData[indexPath.row]["projecttitle"] as? String ?? ""
            cell.images = imageArr
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 550
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let controller = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
            controller.isView = true
            viewForCell = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
