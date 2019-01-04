//
//  chooseAddPaymentMethodVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/31/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class chooseAddPaymentMethodVC: UIViewController {

  
    @IBOutlet weak var addCardBtn: UIButton!
    @IBOutlet weak var addPromoteCoteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //setAlignmentForBnt()
        
    
        
    }
    
    
    
    
    func setAlignmentForBnt() {
        
        
        addCardBtn.contentHorizontalAlignment = .left
        addPromoteCoteBtn.contentHorizontalAlignment = .left
        

    }
    
    
    
    @IBAction func addPromoteBtnPressed(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "MoveToPromoteCodeVC", sender: nil)
        
        
        showErrorAlert("Sorry !!!", msg: "Comming soon")
        
    }
    @IBAction func addCardBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToAddCardVC", sender: nil)
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    

}
