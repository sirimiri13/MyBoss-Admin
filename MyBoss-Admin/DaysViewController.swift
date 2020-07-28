//
//  DaysViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/25/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class DaysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableDaysView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    var date = Date()
    let db = Firestore.firestore()
    var fullName: String = ""
    var email: String = ""
    var listDays:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDaysView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData(){
        let month = date.getCurrentMonth(date: date)
        print(month)
        nameLabel.text = fullName
        db.collection("attendance").document(email).collection("days").getDocuments { (snap, err) in
            if snap!.count > 0 {
                for i in snap!.documents{
                    if (i.documentID == month) {
                        self.db.collection("attendance").document(self.email).collection("days").document(month).getDocument { (snapDate, err) in
                            let date = snapDate?.data()!["date"] as! NSArray
                            for i in date {
                                var j = i as! String
                                if (j != "") {
                                    self.listDays.append(j)
                                    self.tableDaysView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableDaysView.dequeueReusableCell(withIdentifier: "DaysInMonthCell", for: indexPath)
        cell.textLabel?.text = listDays[indexPath.row]
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
