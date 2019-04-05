//
//  DashboardVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/3/19.
//  Copyright © 2019 Campus Connect LLC. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func RideBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "MoveToMapView5", sender: nil)
    }
    
}
