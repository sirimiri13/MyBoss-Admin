//
//  SignUpViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 6/23/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SignUpViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errMess: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setElement()
        
        // Do any additional setup after loading the view.
    }
    
    func setElement(){
       // Utilities.isPasswordValid(pwTextField.text!)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(pwTextField)
        Utilities.styleTextField(confirmPwTextField)
        Utilities.styleFilledButton(signUpButton)
        errMess.alpha = 0
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pw = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPw = confirmPwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (Utilities.isPasswordValid(pw)){
        if (confirmPw == pw){
        Auth.auth().createUser(withEmail: email, password: pw) { (res, err) in
            if (err != nil){
               self.showError(message: err!.localizedDescription)
            }
            else {
                self.db.collection("admin").document(email).setData(["Email" : email])
              //  self.db.collection("attendance").document(email).setData(["start" : 0,"end":0])
               let alert = UIAlertController(title: "Successful", message: "The account is created", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ action in
                self.dismiss(animated: true, completion: nil)

               }))
               self.present(alert, animated: true, completion: nil)
            }
        }
        }
        else {
            self.showError(message: "Password is not matched")
        }
    }
        else {
            self.showError(message: "Please check your password is least 8 characters, contains a special character and a number")
        }
    }
    
    func showError(message: String){
        errMess.text = message
        errMess.textColor = .red
        errMess.alpha = 1
         }
    
    
}
