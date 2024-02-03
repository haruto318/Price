//
//  LoginViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet var signInBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //email text field
        self.loginEmailTextField.delegate = self
        loginEmailTextField.layer.borderColor = UIColor.clear.cgColor
        loginEmailTextField.layer.borderWidth = 1.0
        loginEmailTextField.layer.cornerRadius = 10
        loginEmailTextField.clipsToBounds = true
        loginEmailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        //password text field
        self.loginPasswordTextField.delegate = self
        loginPasswordTextField.layer.borderColor = UIColor.clear.cgColor
        loginPasswordTextField.layer.borderWidth = 1.0
        loginPasswordTextField.layer.cornerRadius = 10
        loginPasswordTextField.clipsToBounds = true
        loginPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        //sign in button
        signInBtn.layer.borderColor = UIColor.clear.cgColor
        signInBtn.layer.borderWidth = 1.0
        signInBtn.layer.cornerRadius = 10
        signInBtn.clipsToBounds = true


    }

    
    @IBAction func tapLoginButton(_ sender: Any) {
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text{
            // Login with email and password on FirebaseAuth
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    print("Completed reginteration email:" + email)
                    // when login success, move to HomeViewController
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "toHome") as! UITabBarController
                    next.selectedIndex = 0

                    next.modalPresentationStyle = .fullScreen
                    self.present(next, animated: true, completion: nil)

                } else if let error = error {
                    //when login fail
                    print("Firebase Auth registeration failed " + error.localizedDescription)
                    let dialog = UIAlertController(title: "registeration failed", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func tapMoveToRegister(){
        self.performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginEmailTextField.resignFirstResponder()
        loginPasswordTextField.resignFirstResponder()
        return true
    }

}
