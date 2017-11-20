//
//  ProfileVC.swift
//  devslopes-social
//
//  Created by Rebecca on 11/20/17.
//  Copyright © 2017 Rebecca. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: CircleView!
    @IBOutlet weak var usernameField: FancyField!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var imageLbl: UILabel!
    @IBOutlet weak var invalidImgLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    var prof = [Profile]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var pro: Profile!
    var profileRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(sender:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        profileImage.isUserInteractionEnabled = true
        
    }
    
    func configureProfile(profile: Profile, img: UIImage? = nil) {
        self.pro = profile
        profileRef = DataService.ds.REF_USER_CURRENT.child("imageUrl").child(profile.profileKey)
        self.usernameField.text = profile.username
        
        if img != nil {
            self.profileImage.image = img
        } else {
            let ref = Storage.storage().reference(forURL: pro.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("WINEGAR: Unable to download image from Firebase storage")
                } else {
                    print("WINEGAR: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: self.pro.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }

    
    func profileImageTapped(sender: UITapGestureRecognizer) {
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.profileImage.image = UIImage()
            }
        })
    }

    

}
