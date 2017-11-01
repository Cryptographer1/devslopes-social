//
//  SignInVC.swift
//  devslopes-social
//
//  Created by Rebecca on 10/20/17.
//  Copyright © 2017 Rebecca. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!    
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("WINEGAR: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
//                self.completeSignIn(id: user.uid)
//            }
//        }
//    }
    
        func firebaseAuth(_ credential: AuthCredential) {
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("WINEGAR: Unable to authenticate with Firebase - \(String(describing: error))")
                } else {
                    print("WINEGAR: Successfully authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                }
                
            })
        }
    }
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("WINEGAR: Email user authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("WINEGAR: Unable to authenticate with Firebase using email")
                        } else {
                            print("WINEGAR: Successfully authenticated with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("WINEGAR: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

