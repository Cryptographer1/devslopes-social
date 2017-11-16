//
//  ProfileVC.swift
//  devslopes-social
//
//  Created by Rebecca on 11/15/17.
//  Copyright © 2017 Rebecca. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: CircleView!
    @IBOutlet weak var usernameField: FancyField!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var imageLbl: UILabel!
    @IBOutlet weak var invalidImgLbl: UILabel!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            imageSelected = true
        } else {
            self.invalidImgLbl.isHidden = false
            self.footerView.backgroundColor = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
            self.profileLbl.isHidden = true
            print("WINEGAR: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func profileImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        guard let username = usernameField.text, username != "" else {
            self.usernameLbl.isHidden = false
            self.footerView.backgroundColor = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
            self.profileLbl.isHidden = true
            print("WINEGAR: Username must be entered")
            return
        }
        guard let img = profileImage.image, imageSelected == true else {
            self.imageLbl.isHidden = false
            self.footerView.backgroundColor = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
            self.profileLbl.isHidden = false
            print("WINEGAR: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_USER_IMAGES.child(imgUid).putData(imgData, metadata: metadata) {
                (metadata, error) in
                if error != nil {
                    print("WINEGAR: Successfully loaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.sendToFirebase(imgUrl: url)
                    }
                }
            }
        }
        //perform segue "goToFeed"
    }
    
    func sendToFirebase(imgUrl: String) {
        let send: Dictionary<String, AnyObject> = [
        "username": usernameField.text! as AnyObject,
        "imageUrl": imgUrl as AnyObject
        ]
        
        let firebaseSend = DataService.ds.REF_USERS.childByAutoId()
        firebaseSend.setValue(send)
        
        usernameField.text = ""
        imageSelected = false
        profileImage.image = UIImage(named: "")
    }
    
}
