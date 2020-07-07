//
//  ViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 6/17/20.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var test: UILabel!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        testFirebase()
        // Do any additional setup after loading the view.
    }
    func testFirebase(){
        db.collection("user").getDocuments { (snap, err) in
            print(snap?.documents.count)
        }
        
    }
    
}



