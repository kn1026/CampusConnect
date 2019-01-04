//
//  DriverLicsVC.swift
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

class DriverLicsVC: UIViewController, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var DriverLics: VSTextField!
    @IBOutlet weak var StateLics: VSTextField!
    let swiftOCRInstance = SwiftOCR()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDayPicker()
        
        if DriverLicsFinal != "", StateLicsFinal != "" {
            
            DriverLics.text = DriverLicsFinal
            StateLics.text = StateLicsFinal
            
        }
        
       
        
        
    }
    
    func createDayPicker() {
        
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        //Customizations
        
        
        StateLics.inputView = dayPicker
        
        
        
        
    }
  
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel1BtnPressed(_ sender: Any) {
        
       self.dismiss(animated: true, completion: nil)
        
    }
 
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        
        if DriverLics.text != "", StateLics.text != "", DriverLics.text.count > 5 {
            DriverLicsCheck = true
            DriverLicsFinal = DriverLics.text
            StateLicsFinal = StateLics.text
            self.dismiss(animated: true, completion: nil)
        }
       
        
    }
}

extension DriverLicsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return AState.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return AState[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        
        StateLics.text = AState[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.text = AState[row]
        label.textAlignment = .center
        return label
        
        
        
        
        
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}
