//
//  RegisterViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet weak var registerAddressTextField: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        if let email = registerEmailTextField.text,
           let password = registerPasswordTextField.text,
           let name = registerNameTextField.text,
           let address = registerAddressTextField.text{
            // Create account with email and password on FirebaseAuth①FirebaseAuthにemailとpasswordでアカウントを作成する
                Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("Completed reginteration uid:" + user.uid)
                    // Create data by uid which login to usercollection of Firestore
                    Firestore.firestore().collection("store").document(user.uid).setData([
                        "name": name, "address": address
                    ], completion: { error in
                        if let error = error {
                            // when creating data fail
                            print("Firestore registeration failed " + error.localizedDescription)
                            let dialog = UIAlertController(title: "Firestore registeration failed", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                        } else {
                            print("Completed reginteration name:" + name)
                            // ③ when success, move to ProductListViewController
                            let storyboard: UIStoryboard = self.storyboard!
                            let next = storyboard.instantiateViewController(withIdentifier: "ProductListViewController")
                                self.present(next, animated: true, completion: nil)
                        }
                    })
                } else if let error = error {
                    //when creating account fail
                    print("Firebase Auth registeration failed " + error.localizedDescription)
                    let dialog = UIAlertController(title: "registeration failed", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            })
        }
    }

}
