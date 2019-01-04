//
//  addNewPromoteVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/31/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase

class addNewPromoteVC: UIViewController {

    @IBOutlet weak var promoteTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        promoteTxtField.layer.borderColor = UIColor.black.cgColor
        promoteTxtField.layer.borderWidth = 1.0
        promoteTxtField.layer.cornerRadius = 5.0
        
        promoteTxtField.becomeFirstResponder()
        
        
    }

    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func submitCodeBtnPressed(_ sender: Any) {
        
        
        
        if let code = promoteTxtField.text, code != "" {
            
            let ref =  DataService.instance.mainDataBaseRef.child("Promote_code").child(userUID).childByAutoId()
            let key = ref.key
            
            let paymentInfo: Dictionary<String, AnyObject> = ["Last4": 1234 as AnyObject, "Exp_month": 9 as AnyObject, "Brand": "Promote_code" as AnyObject, "Id": code as AnyObject, "Exp_year": 2019 as AnyObject, "Funding": "Campus Connect" as AnyObject, "Fingerprint": key as AnyObject, "Country": "United States" as AnyObject, "TimeStamp": ServerValue.timestamp() as AnyObject]
            
             NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "refreshPayment")), object: nil)
            
            ref.setValue(paymentInfo)
            self.dismiss(animated: true, completion: nil)
            
            
            
        }
        
        
        
        
    }
    
}
