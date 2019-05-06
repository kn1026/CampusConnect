
//
//  reportVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/16/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase

class reportVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var reportTxtField: CommentTxtView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reportTxtField.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }

    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        if reportTxtField.text != "", reportTxtField.text != "Comment" {
            
            
            if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                
                if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                    
                    DataService.instance.mainDataBaseRef.child("Report").childByAutoId().setValue(["UID": userUID, "Timestamp": ServerValue.timestamp(), "Content": reportTxtField.text, "Name": name!, "Email": email!, "Title": "In-app issue"])
                    
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                        showCloseButton: false,
                        dynamicAnimatorActive: true,
                        buttonsLayout: .horizontal
                    )
                    
                    let alert = SCLAlertView(appearance: appearance)
                    
                    _ = alert.addButton("Got it") {
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    let icon = UIImage(named:"lg1")
                    
                    _ = alert.showCustom("Thanks!", subTitle: "We will review your issue in 24 hours. Thank you for helping us improve Campus Connect. ", color: UIColor.black, icon: icon!)
                    
                    
                    self.view.endEditing(true)
                    
                    
                }
                
                
            } else {
                
                self.showErrorAlert("Oops!", msg: "Unkown error happens, please try again")
                
                
            }
            
            
            
            
            
            
            
            
        } else {
            
            self.showErrorAlert("Oops!", msg: "Please provide your problem.")
            
            
        }
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Message" {
            
            textView.text = ""
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" || textView.text == "Message" {
            
            textView.text = "Message"
            
        }
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
