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
    @IBOutlet weak var deleteAccountLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var deleteView: FancyView!
    @IBOutlet weak var deleteLbl: UILabel!
    @IBOutlet weak var deleteWarnLbl: UILabel!
    @IBOutlet weak var cancelBtn: FancyBtn!
    @IBOutlet weak var deleteBtn: FancyBtn!
    
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
        
//        DataService.ds.REF_PROFILE.observe(.value, with: { (snapshot) in
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                for snap in snapshots {
//                    print("SNAP: \(snap)")
//                    if let profileDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let proFile = Profile(profileKey: key, profileData: profileDict)
//                        self.prof.append(proFile)
//                    }
//                }
//            }
//        })
        
    }
    
    func configureProfile(profile: Profile, img: UIImage? = nil) {
        self.pro = profile
//        profileRef = DataService.ds.REF_USER_CURRENT.child("imageUrl").child(profile.profileKey)
        self.usernameField.text = profile.username
        
        if img != nil {
            self.profileImage.image = img
        } else {
            let ref = Storage.storage().reference(forURL: profile.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("WINEGAR: Unable to download image from Firebase storage")
                } else {
                    print("WINEGAR: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: profile.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
//        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                self.profileImage.image = UIImage()
//            }
//        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            imageSelected = true
        } else {
            print("WINEGAR: A valid image wasn't selected")
            self.invalidImgLbl.isHidden = false
            self.footerView.backgroundColor = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
            self.profileLbl.isHidden = true
            self.imageLbl.isHidden = true
            self.usernameLbl.isHidden = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        
        guard let username = usernameField.text, username != "" else {
            self.usernameLbl.isHidden = false
            self.footerView.backgroundColor = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
            self.profileLbl.isHidden = true
            self.invalidImgLbl.isHidden = true
            self.imageLbl.isHidden = true
            print("WINEGAR: Username must be entered")
            return
        }
        guard let img = profileImage.image, imageSelected == true else {
            self.imageLbl.isHidden = false
            self.footerView.backgroundColor = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
            self.profileLbl.isHidden = true
            self.invalidImgLbl.isHidden = true
            self.usernameLbl.isHidden = true
            print("WINEGAR: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_PROFILE_IMAGES.child(imgUid).putData(imgData, metadata: metadata) {
                (metadata, error) in
                if error != nil {
                    print("WINEGAR: Unable to upload image to Firebase storage")
                } else {
                    print("WINEGAR: Successfully loaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.sendToFirebase(imgUrl: url)
                    }
                }
            }
        }
        performSegue(withIdentifier: "goToFeedPVC", sender: nil)
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        deleteView.isHidden = false
        deleteLbl.isHidden = false
        deleteWarnLbl.isHidden = false
        cancelBtn.isHidden = false
        deleteBtn.isHidden = false
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        deleteView.isHidden = true
        deleteLbl.isHidden = true
        deleteWarnLbl.isHidden = true
        cancelBtn.isHidden = true
        deleteBtn.isHidden = true
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            user.delete(completion: nil)
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            print("WINEGAR: ID removed from keychain \(keychainResult)")
            try! Auth.auth().signOut()
        } else {
            self.deleteAccountLbl.isHidden = false
            self.footerView.backgroundColor = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
            self.profileLbl.isHidden = true
        }
        
        performSegue(withIdentifier: "goToSignInPVC", sender: nil)
    }
    
    func sendToFirebase(imgUrl: String) {
        let send: Dictionary<String, AnyObject> = [
            "username": usernameField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject
        ]
        
        let firebaseSend = DataService.ds.REF_PROFILE.childByAutoId()
        firebaseSend.setValue(send)
        print("WINEGAR: \(String(describing: usernameField.text))")
        
        usernameField.text = ""
//        imageSelected = false
//        profileImage.image = UIImage(named: "profile-placeholder")
    }

    
    @objc func profileImageTapped(sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
}
