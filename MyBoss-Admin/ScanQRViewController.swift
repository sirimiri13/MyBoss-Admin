//
//  ScanQRViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/01/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import SwiftQRScanner


class ScanQRViewController: UIViewController {  
    var qrCodeFrameView: UIView?
    var  afterSuccessfullySelected: ((_ item: String?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func ScanTapped(_ sender: Any) {
        //QRCode scanner without Camera switch and Torch
        let scanner = QRCodeScannerController()
        scanner.delegate = self
        self.present(scanner,animated: true)
        self.navigationController?.navigationBar.topItem?.title = "SCANNER"
        //     self.navigationController?.show(scanner, sender: self)
    }
    
    }
    extension ScanQRViewController: QRScannerCodeDelegate {
        func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
            print("result:\(result)")
            if let afterSuccessfullySelected = self.afterSuccessfullySelected {
                afterSuccessfullySelected("done")
            }
            let alert = UIAlertController(title: "Scanner", message: "We got ID", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            alert.view.alignmentRect(forFrame: CGRect(x: 50, y: 50, width: 80, height: 50))
            show(alert, sender: self)
     
        }
        
        func qrScannerDidFail(_ controller: UIViewController, error: String) {
            print("error:\(error)")
      
        }
        
        func qrScannerDidCancel(_ controller: UIViewController) {
            print("SwiftQRScanner did cancel")
        }
    }
