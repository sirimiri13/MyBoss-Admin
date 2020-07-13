//
//  HomeViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/11/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseAuth
import Firebase
import JGProgressHUD

struct userSalary{
    var month: String
    var email: String
    var salary: Int
}

struct Salary{
    var month: String
    var user : [userSalary]
    var totalMoney: Int
}

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let formatter = DateFormatter()
    
    var listSalary = [Salary]()
    var listMonth = [String]()
    var listUser = [userSalary]()
    
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    var newPw = UITextField()
    var confirmPw = UITextField()
    @IBOutlet weak var tableSalaryView: UITableView!
    @IBOutlet weak var buttonAcc: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setListSalary()
//        hud.show(in: self.view)
//        DispatchQueue.global(qos: .background).async {
//
//                   self.setListSalary()
//            self.hud.dismiss(animated: true)
//            DispatchQueue.main.async {
//                    self.tableSalaryView.reloadData()
//            }
//
//        }
        tableSalaryView.delegate = self
        tableSalaryView.dataSource = self
        

        tableSalaryView.reloadData()
        formatter.dateFormat = "yyyy/MM/dd"
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
       // self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSalary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryCell", for: indexPath)
        cell.textLabel?.text = listSalary[indexPath.row].month
        let detail = String(listSalary[indexPath.row].totalMoney)
        cell.detailTextLabel?.text = "Total Salary:  \(detail)"
        return cell
    }
    
    
    func getListMonth(){
        listMonth.removeAll()
        db.collection("attendance").getDocuments { (snap, err) in
            for email in snap!.documents {
                let mail = email.documentID
                self.db.collection("attendance").document(mail).collection("Salary").getDocuments { (snapMonth, err) in
                    for month in snapMonth!.documents{
                        let monthSalary = month.documentID
                        self.listMonth.append(monthSalary)
                    }
                }
            }
            print(self.listMonth)
        }
    }
    
    func getListUser(){
        listUser.removeAll()
        db.collection("attendance").getDocuments { (snap, err) in
            for email in snap!.documents{
                let mail = email.documentID
                print(email)
                self.db.collection("attendance").document(mail).collection("Salary").getDocuments { (snapMonth, err) in
                    for month in snapMonth!.documents{
                        let monthSalary = month.documentID
                        print(monthSalary)
                        self.db.collection("attendance").document(mail).collection("Salary").document(monthSalary).getDocument { (snapSalary, err) in
                            let salary = snapSalary?.data()!["Salary"] as! Int
                            let newuser = userSalary(month: monthSalary, email: mail, salary: salary)
                            self.listUser.append(newuser)
                        }
                    }
                }
            }
        }
    }

    func setListSalary(){
        listSalary.removeAll()
        getListUser()
        getListMonth()
        listMonth = listMonth.unique()
        var salary = Salary(month: "", user: [],totalMoney: 0)
        for month in listMonth{
            salary.month = month
            for user in listUser{
                if (user.month == month){
                    salary.user.append(user)
                }
            }
            for i in salary.user{
                salary.totalMoney += i.salary
            }
            self.listSalary.append(salary)
            self.tableSalaryView.reloadData()
            salary.user = []
            salary.totalMoney = 0
        }
        print(listSalary)
    }

    
    @IBAction func managerTapped(_ sender: Any) {
        let alertOption = UIAlertController(title: "Manager", message: "Do you want to Sign Out or Change your password?", preferredStyle: .alert)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (alertOption) in
            let alert = UIAlertController(title: "Sign Out", message: "Please confirm", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (UIAlertAction) in
                try! Auth.auth().signOut()
                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController"))! as! LoginViewController
                vc.modalPresentationStyle =  .fullScreen
                self.present(vc, animated: false)
            }
            alert.addAction(cancelAction)
            alert.addAction(signOutAction)
            self.present(alert,animated: true)
        }
        let changePwAction = UIAlertAction(title: "Change Password", style: .default) { (alertOption) in
                let alertChangePw = UIAlertController(title: "Change Password", message: "Please enter your edit", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let okActionChangePw = UIAlertAction(title: "OK", style: .default, handler: self.changePw(alert:))
                alertChangePw.addTextField { (newPw) in
                    self.newPw(textFiled: newPw)
                }
                alertChangePw.addTextField { (confirmPw) in
                    self.confirmPw(textFiled: confirmPw)
                }
                alertChangePw.addAction(cancelAction)
                alertChangePw.addAction(okActionChangePw)
                self.present(alertChangePw,animated: true)
           
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertOption.addAction(signOutAction)
        alertOption.addAction(changePwAction)
        alertOption.addAction(cancelAction)
        present(alertOption,animated: true)
        
        
    }
    func newPw(textFiled: UITextField) {
        self.newPw = textFiled
        self.newPw.placeholder = "Please enter new password"
        self.newPw.isSecureTextEntry = true
    }
    func confirmPw(textFiled: UITextField) {
        self.confirmPw = textFiled
        self.confirmPw.placeholder = "Please confirm new password"
        self.confirmPw.isSecureTextEntry = true
    }
    
    func changePw(alert: UIAlertAction){
        if (Utilities.isPasswordValid(newPw.text!) == false){
            let alertError = UIAlertController(title: "Error", message:  "Please check your password is least 8 characters, contains a special character and a number", preferredStyle: .alert)
            let tryAction = UIAlertAction(title: "Try again", style: .destructive, handler: nil)
            alertError.addAction(tryAction)
            self.present(alertError,animated: false)
        }
        else {
            hud.show(in: self.view)
            DispatchQueue.global(qos: .background).async {
                if (self.newPw.text == self.confirmPw.text){
                    Auth.auth().currentUser?.updatePassword(to: self.newPw.text!, completion: { (err) in
                        self.hud.dismiss(animated: true)
                        DispatchQueue.main.async {
                            if (err == nil){
                                let alertSuccessful = UIAlertController(title:"Successful", message:  "Your password have been updated", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertSuccessful.addAction(okAction)
                                self.present(alertSuccessful,animated: false)
                            }
                            else {
                                let alertError = UIAlertController(title: "Error", message:  err?.localizedDescription, preferredStyle: .alert)
                                let tryAction = UIAlertAction(title: "Try again", style: .destructive, handler: nil)
                                alertError.addAction(tryAction)
                                self.present(alertError,animated: false)
                            }
                        }
                        
                    })
                }
                else {
                    let alertError = UIAlertController(title: "Error", message:  "Confirm password is wrong", preferredStyle: .alert)
                    let tryAction = UIAlertAction(title: "Try again", style: .destructive, handler: nil)
                    alertError.addAction(tryAction)
                    self.present(alertError,animated: false)
                }
            }
        }
    }
    
    
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
