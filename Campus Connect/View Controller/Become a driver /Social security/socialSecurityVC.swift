//
//  socialSecurityVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/4/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase
import FirebaseAuth
import Alamofire
import Cache
import SwiftOCR


class socialSecurityVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    let swiftOCRInstance = SwiftOCR()
    
    @IBOutlet weak var ssnTxtField: VSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ssnTxtField.keyboardType = .numberPad
        ssnTxtField.delegate = self
        ssnTxtField.becomeFirstResponder()
        
        ssnTxtField.formatting = .socialSecurityNumber
        
        if socialSecurityNum != nil {
            
            ssnTxtField.text = socialSecurityNum
            
        }
        
        
    }
    
    

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        
        
        if ssnTxtField.text?.count == 9 {
            
            socialSecurity = true
            socialSecurityNum = ssnTxtField.text
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        
    }
    
    
    
}
/*
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}
*/
