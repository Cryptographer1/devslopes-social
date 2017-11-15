//
//  ProfileVC.swift
//  devslopes-social
//
//  Created by Rebecca on 11/15/17.
//  Copyright © 2017 Rebecca. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: CircleView!
    @IBOutlet weak var usernameField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func configureProfile(img: UIImage, name: UITextField) {
        
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        
    }
    
}
