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
    let templateColor = UIColor.white
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
//    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errMess: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setElement()
        addingUIElements()
        // Do any additional setup after loading the view.
    }
    let ResgiterLabel: UILabel = {
        let label = UILabel()
        label.text = "REGISTER"
        label.textColor = .white
        label.font = label.font.withSize(30)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    let bgImageView : UIImageView = {
           let imageView = UIImageView()
           imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.image = UIImage(named: "signupbg.jpg")
           imageView.contentMode = .scaleAspectFill
           return imageView
       }()
    let bgView : UIView = {
          let bgView = UIView()
          bgView.translatesAutoresizingMaskIntoConstraints = false
          bgView.backgroundColor = UIColor(displayP3Red: 9.0/255.0, green: 33.0/255.0, blue: 47.0/255.0, alpha: 1.0).withAlphaComponent(0.7)
          return bgView
      }()
    let textFieldView1 : TextFieldView = {
           let textFieldView = TextFieldView()
           textFieldView.translatesAutoresizingMaskIntoConstraints = false
           textFieldView.backgroundColor = UIColor.clear
           return textFieldView
       }()
       
       let textFieldView2 : TextFieldView = {
           let textFieldView = TextFieldView()
           textFieldView.translatesAutoresizingMaskIntoConstraints = false
           textFieldView.backgroundColor = UIColor.clear
           return textFieldView
       }()
    let textFieldView3 : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    let signUpButton : UIButton = {
          let button = UIButton()
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()
    func addingUIElements() {
        let padding: CGFloat = 40.0
        let signInButtonHeight: CGFloat = 50.0
        let textFieldViewHeight: CGFloat = 60.0
        
        self.view.addSubview(bgImageView)
        bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        // Background layer view
        view.insertSubview(bgView, aboveSubview: bgImageView)
        bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        // Label
        view.bringSubviewToFront(ResgiterLabel)
    //    view.insertSubview(ResgiterLabel, aboveSubview: bgView)
//        ResgiterLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250.0).isActive = true
//        ResgiterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
//        ResgiterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    //    ResgiterLabel.heightAnchor.constraint(equalToConstant: ).isActive = true
        
       
        // Email textfield and icon
        view.insertSubview(textFieldView1, aboveSubview: bgView)
        textFieldView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 300.0).isActive = true
        textFieldView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        textFieldView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        textFieldView1.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        textFieldView1.imgView.image = UIImage(named: "profile")
        let attributesDictionary = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        textFieldView1.textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        textFieldView1.textField.textColor = templateColor
        
        // Password textfield and icon
        view.insertSubview(textFieldView2, aboveSubview: bgView)
        textFieldView2.topAnchor.constraint(equalTo: textFieldView1.bottomAnchor, constant: 0.0).isActive = true
        textFieldView2.leadingAnchor.constraint(equalTo: textFieldView1.leadingAnchor, constant: 0.0).isActive = true
        textFieldView2.trailingAnchor.constraint(equalTo: textFieldView1.trailingAnchor, constant: 0.0).isActive = true
        textFieldView2.heightAnchor.constraint(equalTo: textFieldView1.heightAnchor, constant: 0.0).isActive = true
        
        textFieldView2.imgView.image = UIImage(named: "lock")
        textFieldView2.textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
        textFieldView2.textField.isSecureTextEntry = true
        textFieldView2.textField.textColor = templateColor
        
        view.insertSubview(textFieldView3, aboveSubview: bgView)
        textFieldView3.topAnchor.constraint(equalTo: textFieldView2.bottomAnchor, constant: 0.0).isActive = true
        textFieldView3.leadingAnchor.constraint(equalTo: textFieldView2.leadingAnchor, constant: 0.0).isActive = true
        textFieldView3.trailingAnchor.constraint(equalTo: textFieldView2.trailingAnchor, constant: 0.0).isActive = true
        textFieldView3.heightAnchor.constraint(equalTo: textFieldView2.heightAnchor, constant: 0.0).isActive = true
        
        textFieldView3.imgView.image = UIImage(named: "lock")
        textFieldView3.textField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: attributesDictionary)
        textFieldView3.textField.isSecureTextEntry = true
        textFieldView3.textField.textColor = templateColor
        
        // sign Up Button
        //    view.insertSubview(signUpButton, aboveSubview: bgView)
        view.insertSubview(signUpButton, aboveSubview: bgView)
        signUpButton.topAnchor.constraint(equalTo: textFieldView3.bottomAnchor, constant: 20.0).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: textFieldView3.leadingAnchor, constant: 0.0).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: textFieldView3.trailingAnchor, constant: 0.0).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        let buttonAttributesDictionary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0),
                                          NSAttributedString.Key.foregroundColor: templateColor]
        signUpButton.alpha = 0.4
        signUpButton.backgroundColor = UIColor.black
        signUpButton.setAttributedTitle(NSAttributedString(string: "SIGN UP", attributes: buttonAttributesDictionary), for: .normal)
        signUpButton.isEnabled = true
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(button:)), for: .touchUpInside)
    }
      
    
    @objc private func signUpButtonTapped(button: UIButton) {
        let email = textFieldView1.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pw = textFieldView2.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPw = textFieldView3.textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (Utilities.isPasswordValid(pw)){
        if (confirmPw == pw){
        Auth.auth().createUser(withEmail: email, password: pw) { (res, err) in
            if (err != nil){
               self.showAlertVC(title: err!.localizedDescription)
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
                self.showAlertVC(title: "Password is not matched")
        }
    }
        else {
            self.showAlertVC(title: "Please check your password is least 8 characters, contains a special character and a number")
        }
    }
    
   func showAlertVC(title: String) {
        let alertController = UIAlertController(title: "MESSAGE", message: title, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
}
