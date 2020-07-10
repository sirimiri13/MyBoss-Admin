//
//  CreateStaffViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/01/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateStaffViewController: UIViewController {
    @IBOutlet weak var firstNameText: UITextField!
     @IBOutlet weak var lastNameText: UITextField!
     @IBOutlet weak var emailText: UITextField!
     @IBOutlet weak var phoneNumberText: UITextField!
    
    @IBOutlet weak var errorMess: UILabel!
    @IBOutlet weak var createButton: UIButton!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func setElement(){
            errorMess.alpha = 0
            Utilities.styleTextField(lastNameText)
            Utilities.styleTextField(firstNameText)
            Utilities.styleTextField(phoneNumberText)
            Utilities.styleTextField(emailText)
            Utilities.styleFilledButton(createButton)
        }

        @IBAction func createTapped(_ sender: Any) {
            var img = UIImage()
            
            let fName = firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lName = lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = phoneNumberText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: phone!) { (res, err) in
                if (err != nil){
                    self.showError(message: err!.localizedDescription)
                }
                else {
                    let storageRef = Storage.storage().reference().child("QR/\(email)")
                    guard let qrImage = self.generateQRCode(from: email)?.jpegData(compressionQuality: 1) else {return}
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpeg"
                    storageRef.putData(qrImage,metadata: metaData){(metaData,err) in
                    guard metaData != nil else { return}
                        storageRef.downloadURL{(url,err) in
                            guard url != nil else {return}
                        }
                    }
                    let db = Firestore.firestore()
                    db.collection("attendance").document(email).setData(["Start" : "","End": ""])
               
                    db.collection("user").document(email).setData(["QR":"gs://myboss-27d17.appspot.com/QR/\(email)", "FirstName" : fName,"LastName": lName,"Email":email,"Phone": phone,"BasicSalary": "","Overtime": "","avatar": "gs://myboss-27d17.appspot.com/profile/profile.png"]) { (err) in
                        if (err != nil){
                            self.showError(message: err!.localizedDescription)

                        }
                        else {
                            let alert = UIAlertController(title: "Successful", message: "The account is created", preferredStyle: UIAlertController.Style.alert)

                                   // add an action (button)
                                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ action in
                                    self.dismiss(animated: true, completion: nil)
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListUserTableViewController") as! ListUserTableViewController
                               
                                    vc.setListUser()
                                    vc.tableView.reloadData()

                                   }))
                                   self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
        func generateQRCode(from string: String) -> UIImage? {
            let data = string.data(using: String.Encoding.ascii)

            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3, y: 3)

                if let output = filter.outputImage?.transformed(by: transform) {
                    return UIImage(ciImage: output)
                }
            }

            return nil
        }
        func showError(message: String){
            errorMess.text = message
             errorMess.textColor = .red
            errorMess.alpha = 1
             }
        
    }
    extension CreateStaffViewController{
        func HiddenKeyBoard(){
            
            let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
            view.addGestureRecognizer(Tap)
        }
        @objc func textDismissKeyboard(){
            view.endEditing(true)
        }
    }


   

