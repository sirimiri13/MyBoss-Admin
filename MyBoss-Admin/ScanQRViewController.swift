//
//  ScanQRViewController.swift
//  MyBoss-Admin
//
//  Created by Huong Lam on 07/01/2020.
//  Copyright © 2020 Huong Lam. All rights reserved.
//

import UIKit
import SwiftQRScanner
import Firebase
import FirebaseAuth

class ScanQRViewController: UIViewController {
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser?.email
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
           // let date = Calendar.current.
            func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
                let today = Date()
                let formatter3 = DateFormatter()
                formatter3.dateFormat = "yyyy/MM/dd"
                let formatterMMYY = DateFormatter()
                formatterMMYY.dateFormat = "MM y"
                let month = formatterMMYY.string(from: today)
                let timeCheck = formatter3.string(from: today)
                db.collection("attendance").document(result).getDocument { (snap, err) in
                self.db.collection("attendance").document(result).collection("days").document(month).setData(["date": [""]])
                 //   self.db.collection("attendance/\(result)'").addDocument(data: [month :[""]])
                    let temp = snap?.data()!["Start"] as! String
                    if (temp == ""){
                        self.db.collection("attendance").document(result).updateData(["Start" : timeCheck])
                    }
                    else{
                        self.db.collection("attendance").document(result).updateData(["End" : timeCheck])
                        let start = snap?.data()!["Start"] as! String
                        let end = snap?.data()!["Start"] as! String
                        if (start == end){
                          //  self.db.collection("days").document(result).updateData([month : FieldValue.arrayUnion([timeCheck])])
                            self.db.collection("attendance").document(result).collection("days").document(month).updateData(["date" : FieldValue.arrayUnion([timeCheck])])
                            self.db.collection("attendance").document(result).updateData(["End" : "", "Start": ""])
                            
                        }
                        else {
                            self.db.collection("attendance").document(result).updateData(["Start" : timeCheck])
                            self.db.collection("attendance").document(result).updateData(["End" : ""])
                        }
                    
                    }
                }
                print("result:\(result)")
                if let afterSuccessfullySelected = self.afterSuccessfullySelected {
                    afterSuccessfullySelected("done")
                    let alert = UIAlertController(title: "Scanner", message: "We got ID", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    present(alert,animated: true)
                }
    //            let alert = UIAlertController(title: "Scanner", message: "We got ID", preferredStyle: .alert)
    //            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    //            alert.addAction(okAction)
    //            present(alert,animated: true)
            }

            func qrScannerDidFail(_ controller: UIViewController, error: String) {
                print("error:\(error)")

            }

            func qrScannerDidCancel(_ controller: UIViewController) {
                print("SwiftQRScanner did cancel")
            }
        }
