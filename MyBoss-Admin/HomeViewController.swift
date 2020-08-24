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
    var listSalary : [Salary] = []
    var listMonth : [String] = []
    var listUser : [userSalary] = []
    var amountOfStaff : Int = 0
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    var newPw = UITextField()
    var confirmPw = UITextField()
    @IBOutlet weak var tableSalaryView: UITableView!
    @IBOutlet weak var buttonAcc: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.navigationBar.topItem?.title = "HOME"
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        hud.show(in: self.view)
        DispatchQueue.global(qos: .background)
        hud.dismiss(animated: true)
        DispatchQueue.main.async {
            self.getData()
            self.tableSalaryView.reloadData()
        }
        

    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSalary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.formatter.dateFormat = "MM yyyy"
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryCell", for: indexPath)
        cell.textLabel?.text = listSalary[indexPath.row].month
        let detail = String(listSalary[indexPath.row].totalMoney)
        cell.detailTextLabel?.text = "Total Salary:  \(detail)"
        return cell
    }
    
    

    // lấy tổng theo tháng
    func getData(){
        listUser.removeAll()
        listMonth.removeAll()
        listSalary.removeAll()
        db.collection("attendance").getDocuments { (snap, err) in
            var countSalary = 0
            for email in snap!.documents {
                let mail = email.documentID
                print(mail)
                
                self.db.collection("attendance").document(mail).collection("Salary").getDocuments { (snapMonth, err) in
                    for month in snapMonth!.documents{
                        let monthSalary = month.documentID
                        countSalary += 1
                        if (self.listMonth.contains(monthSalary) == false){
                            self.listMonth.append(monthSalary)
                            self.tableSalaryView.reloadData()
                        }
                        self.db.collection("attendance").document(mail).collection("Salary").document(monthSalary).getDocument { (snapSalary, err) in
                            let salary = snapSalary?.data()!["Salary"] as! Int
                            let newuser = userSalary(month: monthSalary, email: mail, salary: salary)
                            self.listUser.append(newuser)
                            self.tableSalaryView.reloadData()
                            self.listUser = self.listUser.sorted(by: { (user1: userSalary, user2: userSalary) -> Bool in
                                return user1.month < user2.month
                            })
                            var i = 0
                            var count = 0
                            var temp = Salary(month: self.listUser[0].month, user: [self.listUser[0]], totalMoney: 0)
                            while ((i < self.listUser.count - 1) && (self.listUser.count == countSalary)) {
                                print(i)
                                for j in i+1...self.listUser.count-1{
                                    
                                    if (self.listUser[i].month == self.listUser[j].month){
                                        temp.user.append(self.listUser[j])
                                        count += 1
                                    }
                                    else {
                                        var totalMoney = 0
                                        for i in temp.user{
                                            totalMoney += i.salary
                                        }
                                        temp.totalMoney = totalMoney
                                        self.listSalary.append(temp)
                                        print(self.listSalary)
                                        self.tableSalaryView.reloadData()
                                        i = i + count + 1
                                        temp.month = self.listUser[i].month
                                        temp.user.removeAll()
                                        temp.user.append(self.listUser[i])
                                        count = 0
                                    }
                                    if (j == self.listUser.count - 1){
                                        var totalMoney = 0
                                        for i in temp.user{
                                            totalMoney += i.salary
                                        }
                                        temp.totalMoney = totalMoney
                                        i = i + count + 1
                                        self.listSalary.append(temp)
                                        print(self.listSalary)
                                        self.tableSalaryView.reloadData()
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetail" {
            let vc = segue.destination as! DetailSalaryViewController
            guard let indexPath = tableSalaryView.indexPathForSelectedRow else {return}
            vc.listSalary = listSalary[indexPath.row]
            
        }
    }
    

}
