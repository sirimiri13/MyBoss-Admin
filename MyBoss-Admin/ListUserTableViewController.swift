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
    let db = Firestore.firestore()
    var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setListUser()
        
        addButton = UIBarButtonItem(title: "test", style: .done, target: self, action: #selector(addButtonAction(_:)))
      //  self.navigationItem.rightBarButtonItem = self.addButton
//        navBar.rightBarButtonItem = self.addButton
//        navBar.title = "STAFF"
        tableView.reloadData()
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
        let lastName = listUser[indexPath.row].lastName as String
        let firstName = listUser[indexPath.row].firstName as String
        let fullName = firstName + " " + lastName
        cell.textLabel?.text = fullName
        return cell
        
    }

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
    
    @objc func addButtonAction(_ sender: UIBarButtonItem) {
          print("Test Right button", self.navigationItem.title)
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