//
//  phoneVerifiedVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SinchVerification
import SCLAlertView


class phoneVC: UIViewController, UITextFieldDelegate {
    
    
    
    var name: String?
    var birthday: String?
    
    var phoneNumber: String?
    
    
    var verification: Verification!
    

    @IBOutlet weak var phoneNumberWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberTxtView: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // phoneNumberWidthConstraint.constant = phoneNumberWidthConstraint.constant * (327/375)
        
        
        if userType == "fb" {
            
            try! Auth.auth().signOut()
            
        }
             
        phoneNumberTxtView.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: phoneNumberTxtView.frame.size.height - width, width:  phoneNumberTxtView.frame.size.width + 30, height: phoneNumberTxtView.frame.size.height)
        
        border.borderWidth = width
        phoneNumberTxtView.layer.addSublayer(border)
        phoneNumberTxtView.layer.masksToBounds = true
        
        phoneNumberTxtView.delegate = self
        
        phoneNumberTxtView.keyboardType = .numberPad
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneNumberTxtView.becomeFirstResponder()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        
        
        if phoneNumberTxtView.text != "" {
            
            self.swiftLoader()
            if let phone = phoneNumberTxtView.text {
                let finalPhone = "+1\(phone)"
                createdPhone = finalPhone
                self.phoneNumber = finalPhone
                
                
                
                
                self.verification = SMSVerification(applicationKey, phoneNumber: finalPhone)
                
                
                
                self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                    
                    if error != nil {
                        
                        SwiftLoader.hide()
                        self.showErrorAlert("Oopps !!!", msg: (error?.localizedDescription)!)
                        
                        
                        return
                    }
                    
                    SwiftLoader.hide()
                    self.performSegue(withIdentifier: "moveToPhoneVerifiedVC", sender: nil)
                    
                    
                }
       
            }
            
            
            
        } else {
            
            self.showErrorAlert("Oopps !!!", msg: "Please enter a phone number")
            
            
        }
       
       
        
    }
    
    func alertUserCode() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        
        _ = alert.addButton("Next") {
            
            
            
            self.performSegue(withIdentifier: "moveToPhoneVerifiedVC", sender: nil)
            
            
        }
        
        let icon = UIImage(named:"lg1")
        
        _ = alert.showCustom("Notice !!!", subTitle: "Due to some internal error from our system, you won't receive any code to your phone number, using 230517 as verified code to keep moving.", color: UIColor.black, icon: icon!)
        
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "moveToPhoneVerifiedVC"{
            if let destination = segue.destination as? VerifiedPhoneVC
            {
               
                destination.birthday = self.birthday
                destination.name = self.name
                destination.phoneNumber = self.phoneNumber
                destination.verification = verification
            }
        }
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
        
        
        
        
        
    }
}
