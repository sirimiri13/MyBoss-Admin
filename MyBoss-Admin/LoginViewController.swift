//
//  LoginViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 6/23/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD




class LoginViewController: UIViewController {
    let db = Firestore.firestore()
    let templateColor = UIColor.white
    
    let bgImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "loginAdmin.jpg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let errorLabel : UILabel = {
        let errLabel = UILabel()
        // errLabel.alpha = 0
        return errLabel
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
    
    let signInButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPassword : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addingUIElements()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let today = formatter.string(from: date)
        let tempToday = formatter.date(from: today)
        let firstDay = formatter.string(from: Date().startOfMonth)
        let tempFirstDay = formatter.date(from: firstDay)
        
        if (tempToday == tempFirstDay){
            let previousMonth = date.getPreviousMonth(date: date)
            db.collection("attendance").getDocuments { (snap, err) in
                for doc in snap!.documents {
                    let docID = doc.documentID
                    self.db.collection("attendance").document(docID).collection("days").document(previousMonth).getDocument { (snapDate, err) in
                        let date = snapDate?.data()!["date"] as! NSArray
                        var count = date.count
                        count = count - 1
                        self.db.collection("user").document(docID).getDocument { (snapSalary, err) in
                            let basicSalary = snapSalary?.data()!["BasicSalary"] as! NSString
                            let salaryNum = basicSalary.integerValue
                            let salary = salaryNum * count
                            self.db.collection("attendance").document(docID).collection("Salary").document(previousMonth).setData(["Salary" : salary])
                        }
                    }
                }
            }
            
        }
        self.HiddenKeyBoard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
        errorLabel.backgroundColor = .red
    }
    
    func addingUIElements() {
        let padding: CGFloat = 40.0
        let signInButtonHeight: CGFloat = 50.0
        let textFieldViewHeight: CGFloat = 60.0
        
        // Background imageview
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
        
        
        
        // Sign In Button
        view.insertSubview(signInButton, aboveSubview: bgView)
        signInButton.topAnchor.constraint(equalTo: textFieldView2.bottomAnchor, constant: 20.0).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: textFieldView2.leadingAnchor, constant: 0.0).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: textFieldView2.trailingAnchor, constant: 0.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        let buttonAttributesDictionary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0),
                                          NSAttributedString.Key.foregroundColor: templateColor]
        signInButton.alpha = 0.4
        signInButton.backgroundColor = UIColor.black
        signInButton.setAttributedTitle(NSAttributedString(string: "SIGN IN", attributes: buttonAttributesDictionary), for: .normal)
        signInButton.isEnabled = true
        signInButton.addTarget(self, action: #selector(signInButtonTapped(button:)), for: .touchUpInside)
        
        // Forgot Password Button
        view.insertSubview(forgotPassword, aboveSubview: bgView)
        forgotPassword.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 0.0).isActive = true
        forgotPassword.leadingAnchor.constraint(equalTo: textFieldView1.leadingAnchor, constant: 0.0).isActive = true
        forgotPassword.trailingAnchor.constraint(equalTo: textFieldView1.trailingAnchor, constant: 0.0).isActive = true
        
        forgotPassword.setTitle("Forgot password?", for: .normal)
        forgotPassword.setTitleColor(templateColor, for: .normal)
        forgotPassword.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        forgotPassword.addTarget(self, action: #selector(forgotPasswordButtonTapped(button:)), for: .touchUpInside)
        
        // sign Up Button
        view.insertSubview(signUpButton, aboveSubview: bgView)
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10.0).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: textFieldView1.leadingAnchor, constant: 0.0).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: textFieldView1.trailingAnchor, constant: 0.0).isActive = true
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(button:)), for: .touchUpInside)
        
        let text = "Don't have an account? Sign Up"
        let attributedString = NSMutableAttributedString.init(string: text)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let detailAttributes = [ NSAttributedString.Key.foregroundColor : templateColor,
                                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0) ,NSAttributedString.Key.paragraphStyle : style]
        
        attributedString.addAttributes(detailAttributes, range: NSMakeRange(0, attributedString.length))
        
        
        let sampleLinkRange1 = text.range(of: "Sign Up")!
        let startPos1 = text.distance(from: text.startIndex, to: sampleLinkRange1.lowerBound)
        let endPos1 = text.distance(from: text.startIndex, to: sampleLinkRange1.upperBound)
        let linkRange1 = NSMakeRange(startPos1, endPos1 - startPos1)
        let linkAttributes1 = [ NSAttributedString.Key.foregroundColor : templateColor,
                                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0)]
        
        attributedString.addAttributes(linkAttributes1, range: linkRange1)
        
        signUpButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @objc private func signInButtonTapped(button: UIButton) {
        let hud = JGProgressHUD(style: .dark)
        let username = textFieldView1.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = textFieldView2.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        hud.show(in: self.view)
        DispatchQueue.global(qos: .background).async {
            Auth.auth().signIn(withEmail: username!, password: pass!) { (res, err) in
                hud.dismiss(animated: true)
                DispatchQueue.main.async {
                    if (err != nil){
                        self.showAlertVC(title: err!.localizedDescription)
                    }
                    else {
                        if let tabbar = (self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController) {
                            let navController = UINavigationController(rootViewController: tabbar)
                            navController.modalPresentationStyle = .fullScreen
                            self.present(navController, animated: true, completion: nil)
                        }
                      
                    }
                }
            }
        }
    }
    
    @objc private func signUpButtonTapped(button: UIButton) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")) as! SignUpViewController
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: false)
    }
    
    @objc private func forgotPasswordButtonTapped(button: UIButton) {
        showAlertVC(title: "Forgot password tapped")
    }
    
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: title, message: "Need to implement code based on user requirements", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
//
//    func getListMonth(){
//        db.collection("attendance").getDocuments { (snap, err) in
//            for email in snap!.documents{
//                let mail = email.documentID
//                self.db.collection("attendance").document(mail).collection("Salary").getDocuments { (snapMonth, err) in
//                    for month in snapMonth!.documents{
//                        let monthSalary = month.documentID
//                        self.listMonth.append(monthSalary)
//                        //  print(self.listMonth)
//
//                    }
//                }
//            }
//        }
//    }
//    func getListUser(){
//        db.collection("attendance").getDocuments { (snap, err) in
//            for email in snap!.documents{
//                let mail = email.documentID
//                self.db.collection("attendance").document(mail).collection("Salary").getDocuments { (snapMonth, err) in
//                    for month in snapMonth!.documents{
//                        let monthSalary = month.documentID
//                        self.db.collection("attendance").document(mail).collection("Salary").document(monthSalary).getDocument { (snapSalary, err) in
//                            let salary = snapSalary?.data()!["Salary"] as! Int
//                            let newuser = userSalary(month: monthSalary, email: mail, salary: salary)
//                            self.listUser.append(newuser)
//                            //  print(self.listUser)
//                        }
//                    }
//                }
//            }
//
//        }
//    }
    
}

class TextFieldView: UIView {
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let lineView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addingSubviews()
    }
    
    func addingSubviews() {
        self.addSubview(lineView)
        lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        self.addSubview(imgView)
        imgView.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -15.0).isActive = true
        imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor, constant: 0.0).isActive = true
        
        self.addSubview(textField)
        textField.lastBaselineAnchor.constraint(equalTo: imgView.lastBaselineAnchor, constant: -1.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8.0).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension LoginViewController{
    func HiddenKeyBoard(){
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func textDismissKeyboard(){
        view.endEditing(true)
    }
}

extension Date {
    
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    func getPreviousMonth(date: Date) -> String {
        let formatterMMYYYY = DateFormatter()
        formatterMMYYYY.dateFormat = "MM yyyy"
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)
        return formatterMMYYYY.string(from: previousMonth!)
    }
    
    
}


