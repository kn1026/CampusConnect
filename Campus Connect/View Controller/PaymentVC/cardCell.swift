//
//  cardCell.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/28/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class cardCell: MGSwipeTableCell {
    
    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var cardInfo: UILabel!
    @IBOutlet weak var cardExp: UILabel!
    var info: PaymentModel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func configureCell(_ Information: PaymentModel) {
        
        
        self.info = Information
 
        
        if info.Brand == "Apple_pay" {
            
            self.cardInfo.text = "Apple pay"
            self.cardExp.text = ""
            let icon = UIImage(named: "Apple pay")
            cardImg.image = icon
            
        } else if info.Brand == "Promote_code" {
            
            self.cardInfo.text = "Promote code - Free ride"
            
            if info.Exp_month < 10 {
                
                self.cardExp.text = "Expires: 0\(info.Exp_month!)/\(info.Exp_year!)"
                
            } else {
                
                self.cardExp.text = "Expires: \(info.Exp_month!)/\(info.Exp_year!)"
                
            }
            
            let icon = UIImage(named: "lg")
            cardImg.image = icon
            
            
            
        } else {
            
            if info.Exp_month < 10 {
                
                self.cardExp.text = "Expires: 0\(info.Exp_month!)/\(info.Exp_year!)"
                
            } else {
                
                self.cardExp.text = "Expires: \(info.Exp_month!)/\(info.Exp_year!)"
                
            }
            
            self.cardInfo.text = " •••• \(info.Last4!)"
            
            let icon = UIImage(named: info.Brand)
            cardImg.image = icon
            
        }
        
        
        
        
    }

}
