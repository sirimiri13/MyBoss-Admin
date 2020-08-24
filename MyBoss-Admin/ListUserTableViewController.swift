//
//  ListUserTableViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 6/23/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
struct User{
    var firstName: String
    var lastName: String
    var phone: String
    var email: String
    var salary: String
    var profileImage: String
}


class ListUserTableViewController: UITableViewController {
    var listUser: [User] = []
    let hud = JGProgressHUD(style: .dark)
    let db = Firestore.firestore()
    var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setListUser()
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        listUser.removeAll()
        setListUser()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listUser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath)
    //    cell.backgroundColor = .blue
        let lastName = listUser[indexPath.row].lastName as String
        let firstName = listUser[indexPath.row].firstName as String
        let fullName = firstName + " " + lastName
        cell.textLabel?.text = fullName
        return cell
        
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

           guard section == 0 else { return nil } // Can remove if want button for all sections

           let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 80))
           footerView.backgroundColor = .systemBlue
           let myButton = UIButton(type: .custom)

                   myButton.setTitle("ADD STAFF", for: .normal)
                   myButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
                 //  myButton.tintColor = .systemBlue
                   myButton.setTitleColor(UIColor.black, for: .normal) //set the color this is may be different for iOS 7
                   myButton.frame = CGRect(x: 0, y: 0, width: 414, height: 35) //set some large width to ur title
                   footerView.addSubview(myButton)
                   return footerView;

       }
    
    // set 2 button info và day
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let infoAction = UITableViewRowAction(style: .default, title: "INFORMATION" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
            vc.fName = self.listUser[indexPath.row].firstName
            vc.lName = self.listUser[indexPath.row].lastName
            vc.profileImage = self.listUser[indexPath.row].profileImage
            vc.email = self.listUser[indexPath.row].email
            vc.phone = self.listUser[indexPath.row].phone
            vc.salary = self.listUser[indexPath.row].salary
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: true)
        })
        let daysAction = UITableViewRowAction(style: .default, title: "DAYS IN MONTH" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DaysViewController") as! DaysViewController
            let fName = self.listUser[indexPath.row].firstName
            let lName = self.listUser[indexPath.row].lastName
            let fullName = fName + " " + lName
            vc.fullName = fullName
            vc.email = self.listUser[indexPath.row].email
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: true)
        })
        daysAction.backgroundColor = .systemBlue
        return [infoAction,daysAction]
    }
    
    // tạo tàikhoarn mới
    @objc func addTapped(_ sender: AnyObject){
        let vc = (storyboard?.instantiateViewController(withIdentifier: "CreateStaffViewController"))! as! CreateStaffViewController
       // self.present(vc,animated: true)
        show(vc, sender: nil)
    }

    
    // lấy danh sách nhân viên từ fb về 
    func setListUser(){
        navigationController?.navigationBar.topItem?.title = "STAFF"
        navigationController?.navigationItem.rightBarButtonItem = self.addButton
        //navigationController?.navigationBar.navigationItem.rightBarButtonItem = self.addButton
        db.collection("user").getDocuments { (snap, err) in
            for user in snap!.documents{
                let firstName = user.data()["FirstName"] as! String
                let lastName = user.data()["LastName"] as! String
                let email = user.data()["Email"] as! String
                let phone = user.data()["Phone"] as! String
                let profileImage = user.data()["avatar"] as! String
                let salary = user.data()["BasicSalary"] as! String
                let mem = User(firstName: firstName, lastName: lastName, phone: phone, email: email, salary: salary, profileImage: profileImage)
                self.listUser.append(mem)
            }
            self.tableView.reloadData()
        }
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoInformation" {
            let vc = segue.destination as! InformationViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            vc.fName = listUser[indexPath.row].firstName
            vc.lName = listUser[indexPath.row].lastName
            vc.profileImage = listUser[indexPath.row].profileImage
            vc.email = listUser[indexPath.row].email
            vc.phone = listUser[indexPath.row].phone
            vc.salary = listUser[indexPath.row].salary
        }
    }
    


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
