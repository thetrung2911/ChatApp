//
//  HomeViewController.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/27/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import SVProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet var screenF1Button: UIButton!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    private var user: UserManager?
    private var loginObserver: NSObjectProtocol?
    private var userProfile = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    /// Setting Layout View
    func settingLayout() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: logOutImage), style: .done, target: self, action: #selector(self.onLogOut(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        screenF1Button.setCornerRadius()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let storybroad = UIStoryboard(name: loginStoryboardName, bundle: nil)
            let vc = storybroad.instantiateViewController(withIdentifier: loginViewControllerIdentifier)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        } else {
            let currentUser = FirebaseAuth.Auth.auth().currentUser
            title = currentUser?.email
            getAvatarView()
        }
    }
    
    private func getAvatarView() {
        UIApplication.shared.showLoadingProgress()
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email as? String else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
//        let path = "images/"+filename
        print(safeEmail)
        DatabaseManager.shared.getProfileUser(with: email, completion: { result in
            switch result {
            case .success(let profile):
                self.userProfile = profile
                self.firstNameLabel.text = "First Name: \(self.userProfile["first_name"] ?? "")"
                self.lastNameLabel.text = "First Name: \(self.userProfile["last_name"] ?? "")"
                self.sexLabel.text = "Sex: \(self.userProfile["sex"] ?? "")"
                let path = "images/" + (self.userProfile["urlAvatar"] as! String)
                StorageManager.shared.downloadURL(for: path, completion: { result in
                    switch result {
                    case .success(let url):
                        SVProgressHUD.dismiss()
                        self.avatarView.kf.setImage(with: url)
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print("Failed to get avatar: \(error)")
                    }
                })
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("Failed to get profile: \(error)")
            }
        })
        
        
//        StorageManager.shared.downloadURL(for: path, completion: { result in
//            switch result {
//            case .success(let url):
//                self.avatarView.kf.setImage(with: url)
//            case .failure(let error):
//                print("Failed to get download url: \(error)")
//            }
//        })
    }
    
    
    /// Event Logout
    @objc func onLogOut(sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: loginStoryboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: loginViewControllerIdentifier)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    /// 
    @IBAction func onScreenF1(_ sender: Any) {
        
    }
}
