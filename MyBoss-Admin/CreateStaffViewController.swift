//
//  CreateStaffViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/01/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit

class CreateStaffViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.action(sender:)))
        // Do any additional setup after loading the view.
       // let getLinkButton = UIButton()
      //  self.view.addSubview()
        
    }
    

    @objc func action(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

}
