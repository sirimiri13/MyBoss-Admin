//
//  DetailSalaryViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/20/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class DetailSalaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var listSalary = Salary(month: "", user: [], totalMoney: 0)
    var listUser: [String] = []
    let db = Firestore.firestore()
    let hud = JGProgressHUD(style: .dark)
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableDetailSalary: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.show(in: self.view)
        DispatchQueue.global(qos: .background)
      
        hud.dismiss(animated: true)
        DispatchQueue.main.async {
            self.getData()
            self.tableDetailSalary.reloadData()
        }
        
        print(listSalary)
    }
    override func viewWillAppear(_ animated: Bool) {
       // getData()
    }

    func getData(){
        monthLabel.text = listSalary.month
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSalary.user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableDetailSalary.dequeueReusableCell(withIdentifier: "DetailSalaryCell", for: indexPath)
        db.collection("user").document(listSalary.user[indexPath.row].email).getDocument { (snap, err) in
                       let fName = snap?.data()!["FirstName"] as! String
                       let lName = snap?.data()!["LastName"] as! String
                       let fullName = fName + " " + lName
            cell.textLabel?.text = fullName
            
        }
       // cell.textLabel?.text = listSalary.user[indexPath.row].email
        let detail = listSalary.user[indexPath.row].salary
        cell.detailTextLabel?.text =   String(detail)
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
