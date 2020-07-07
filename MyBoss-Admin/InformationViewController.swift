//
//  InformationViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 6/23/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class InformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var fName: String = ""
    var lName: String = ""
    var phone: String = ""
    var email: String = ""
    var profileImage: String = ""
    var salary: String = ""
    let nav = UINavigationController()
    let db = Firestore.firestore()
    var textEdit: String = ""
    var newPw = UITextField()
    var confirmPw = UITextField()
    let imagePicker = UIImagePickerController()
    var editTextField = UITextField()
    var edit : String = ""
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
     //   self.navigationController?.navigationBar.topItem!.title = "DETAIL"
        setData()

        // Do any additional setup after loading the view.
    }
    
    func setData(){
        firstNameLabel.text = fName
        lastNameLabel.text = lName
        phoneLabel.text = phone
        salaryLabel.text = salary
        emailLabel.text = email
        let ref = Storage.storage().reference(forURL: self.profileImage)
        ref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil {
                self.profileImageView.image = UIImage(data: data!)
            }
        }
    }
 
    @IBAction func editProfileImageTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true)
    }
    @IBAction func editFirstNameTapped(_ sender: Any) {
         self.edit = "FirstName"
        showAlert(textLabel: "FirstName")
              
    }
    @IBAction func editLastNameTapped(_ sender: Any) {
        self.edit = "LastName"
        showAlert(textLabel: "LastName")
    }
    @IBAction func editPhoneTapped(_ sender: Any) {
        self.edit = "Phone"
        showAlert(textLabel: "Phone")
             
    }
    @IBAction func ediitSalaryBasicTapped(_ sender: Any) {
        self.edit = "BasicSalary"
        showAlert(textLabel: "BasicSalary")
    }
    @IBAction func reserPw(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            if (err == nil){
                let alert = UIAlertController(title: "Reset Password", message: "Please check your email", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert,animated: false)
            }
         
        }
    }

    func editTextField(textField: UITextField!){
           editTextField = textField
           editTextField.placeholder = "Enter your edit...."
       }
    func getEditTextField(alert : UIAlertAction){
           self.textEdit = editTextField.text!
           if (self.edit == "LastName"){
               self.lastNameLabel.text = editTextField.text
           }
           if (self.edit == "FirstName"){
               self.firstNameLabel.text = editTextField.text
           }
           if (self.edit == "Phone"){
                      self.phoneLabel.text = editTextField.text
            }
        if (self.edit == "BasicSalary"){
                             self.salaryLabel.text = editTextField.text
                   }
                  
        self.db.collection("user").document(email).updateData([self.edit : self.textEdit])
           
    }
    
    @IBAction func disableTapped(_ sender: Any) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           let storageRef = Storage.storage().reference().child("profile/\(email)")
           guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
               return
           }
           let pickerData = pickedImage.jpegData(compressionQuality: 1)
           let metaData = StorageMetadata()
           metaData.contentType = "image/jpeg"
           storageRef.putData(pickerData!,metadata: metaData){(metaData,err) in
           guard metaData != nil else { return}
               storageRef.downloadURL{(url,err) in
                   guard url != nil else {return}
               }
           }
           let db = Firestore.firestore()
           db.collection("user").document(email).updateData(["avatar": "gs://myboss-27d17.appspot.com/profile/\(email)"])
           //setUpData()
           let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
           profileImageView.image = imagePicked
           dismiss(animated: true, completion: nil)
       }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           self.profileImageView.reloadInputViews()
           dismiss(animated: true, completion: nil)
    }
    func showAlert(textLabel: String){
          let alert = UIAlertController(title: textLabel, message: "Please enter your edit", preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: self.getEditTextField(alert:))
          alert.addTextField { (editTextField) in
              self.editTextField(textField: editTextField)
          }
          alert.addAction(cancelAction)
          alert.addAction(okAction)
          present(alert,animated: true)
          }
      
     
}
    
    
