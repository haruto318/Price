//
//  RegisterViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit
import Firebase
//import FirebaseCore
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerEmailTextField.delegate = self
        registerEmailTextField.layer.borderColor = UIColor.clear.cgColor
        registerEmailTextField.layer.borderWidth = 1.0
        registerEmailTextField.layer.cornerRadius = 10
        registerEmailTextField.clipsToBounds = true
        registerEmailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        self.registerPasswordTextField.delegate = self
        registerPasswordTextField.layer.borderColor = UIColor.clear.cgColor
        registerPasswordTextField.layer.borderWidth = 1.0
        registerPasswordTextField.layer.cornerRadius = 10
        registerPasswordTextField.clipsToBounds = true
        registerPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        self.registerNameTextField.delegate = self
        registerNameTextField.layer.borderColor = UIColor.clear.cgColor
        registerNameTextField.layer.borderWidth = 1.0
        registerNameTextField.layer.cornerRadius = 10
        registerNameTextField.clipsToBounds = true
        registerNameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        signInBtn.layer.borderColor = UIColor.clear.cgColor
        signInBtn.layer.borderWidth = 1.0
        signInBtn.layer.cornerRadius = 10
        signInBtn.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    @IBAction func tapRegisterButton(_ sender: Any) {
        if let email = registerEmailTextField.text,
                    let password = registerPasswordTextField.text,
                    let name = registerNameTextField.text {
                    // ①FirebaseAuthにemailとpasswordでアカウントを作成する
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                        if let user = result?.user {
                            print("ユーザー作成完了 uid:" + user.uid)
                            // ②FirestoreのUsersコレクションにdocumentID = ログインしたuidでデータを作成する
                            Firestore.firestore().collection("users").document(user.uid).setData([
                                "name": name
                            ], completion: { error in
                                if let error = error {
                                    // ②が失敗した場合
                                    print("Firestore 新規登録失敗 " + error.localizedDescription)
                                    let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(dialog, animated: true, completion: nil)
                                } else {
                                    print("ユーザー作成完了 name:" + name)
                                    // ③成功した場合はTodo一覧画面に画面遷移を行う
                                    let storyboard: UIStoryboard = self.storyboard!
                                    let next = storyboard.instantiateViewController(withIdentifier: "toHome") as! UITabBarController
                                    next.selectedIndex = 0
//                                    self.navigationController?.pushViewController(next, animated: true)
                                    next.modalPresentationStyle = .fullScreen
                                    self.present(next, animated: true, completion: nil)
                                }
                            })
                        } else if let error = error {
                            // ①が失敗した場合
                            print("Firebase Auth 新規登録失敗 " + error.localizedDescription)
                            let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                        }
                    })
                }
    }
    
    @IBAction func tapMoveToLogin(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        registerEmailTextField.resignFirstResponder()
        registerPasswordTextField.resignFirstResponder()
        registerNameTextField.resignFirstResponder()
        return true
    }

}
