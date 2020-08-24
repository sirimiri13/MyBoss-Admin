//
//  DetailDaysViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/23/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class DetailDaysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableDetailDays.dequeueReusableCell(withIdentifier: "CellDays", for: indexPath)
        cell.textLabel?.text = Days[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var tableDetailDays: UITableView!
    var Days : [String] = []
    var email: String = ""
    var month: String = ""
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableDetailDays.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // lấy ngày làm việc trong tháng được chọn của nhân viên đc chọn
    
    func getData(){
        db.collection("attendance").document(email).collection("days").document(month).getDocument { (snap, err) in
            let date = snap?.data()!["date"] as! NSArray
            for i in date {
                let j = i as! String
                if (j != ""){
                    self.Days.append(j)
                    self.tableDetailDays.reloadData()
                }
            }
            
        }
    }

}
