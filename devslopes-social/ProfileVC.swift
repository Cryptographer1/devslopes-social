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

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
    }

    
    

    

}
