//
//  DashboardVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/3/19.
//  Copyright © 2019 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase

class DashboardVC: UIViewController {
//"Welcome, User"
    @IBOutlet weak var WelcomeLbl: UILabel!
    @IBOutlet weak var SplashView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        guard Auth.auth().currentUser != nil else {
            
            self.performSegue(withIdentifier: "GoBackToSignIn10", sender: nil)
            return
        }
        
        
        let userDefaults = UserDefaults.standard
        
        
        if userDefaults.bool(forKey: "hasRunIntro") == false {
            
            
            // Run code here for the first launch
            self.performSegue(withIdentifier: "moveToIntroVC3", sender: nil)
            
            
        } else {
            
            
            if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                
                
                let fullNameArr = name?.components(separatedBy: " ")

                
                
                let firstName = fullNameArr![0].firstUppercased
                WelcomeLbl.text = "Welcome, \(firstName)"
                
                
                
                self.SplashView.isHidden = true
                
                
                
                
                
                
            } else{
                
                
                self.performSegue(withIdentifier: "GoBackToSignIn10", sender: nil)
                return
                
            }
            
            
            
            
        }
        
  
        
        
        
    }
    
    @IBAction func RideBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "MoveToMapView5", sender: nil)
    }
    
}
