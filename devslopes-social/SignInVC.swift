//
//  SignInVC.swift
//  devslopes-social
//
//  Created by Rebecca on 10/20/17.
//  Copyright © 2017 Rebecca. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!    
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
//        let facebookLogin = FBSDKLoginManager()
//
//        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
//            if error != nil {
//                print("WINEGAR: Unable to authenticate with Facebook - \(error)")
//            } else if result?.isCancelled == true {
//                print("WINEGAR: User cancelled Facebook authentication")
//            } else {
//                print("WINEGAR: Successfully authenticated with Facebook")
//                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//                self.firebaseAuth(credential)
//            }
//        }
//    }
    
        func firebaseAuth(_ credential: AuthCredential) {
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("WINEGAR: Unable to authenticate with Firebase - \(String(describing: error))")
                } else {
                    print("WINEGAR: Successfully authenticated with Firebase")
                }
                
            })
        }
    }
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("WINEGAR: Email user authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("WINEGAR: Unable to authenticate with Firebase using email")
                        } else {
                            print("WINEGAR: Successfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }
}

