//
//  HomeViewController.swift
//  Civil World
//
//  Created by Apple on 22/06/24.
//

import UIKit
import FirebaseFirestoreInternal

class HomeViewController: UIViewController {
   
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
 }
    


//MARK: ACTIONS
extension HomeViewController{
    @IBAction func sideMenuAction(_ sender: UIButton) {
        toggleSideMenu()
    }
}

//MARK: TableView Delegate&Datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeListingCell") as! HomeListingCell
         
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        controller.userDetail = userData[indexPath.row]["projecttitle"] as? String ?? ""
        controller.statusBtn = userData[indexPath.row]["status"] as? String ?? ""
        
        controller.descriptiontxt = userData[indexPath.row]["projectdetails"] as? String ?? ""
        let vari = userData[indexPath.row]["images"] as? [Data] ?? []
        var imageArr = [UIImage]()
        if vari.count > 0 {
            for i in vari {
                if let image = UIImage(data: i) {
                    imageArr.append(image)
                }
            }
        }
        controller.arrImage = imageArr
        
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension UIViewController {
    func showToast(message: String, duration: Double = 2.0, completion: (() -> Void)? = nil) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75,
                                               y: self.view.frame.size.height - 100,
                                               width: 150,
                                               height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        // Animate the fading out of the toast message
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()  // Remove it once the animation completes
            completion?()  // Call the completion handler if it's provided
        })
    }
}

