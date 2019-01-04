//
//  CampusVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class CampusVC: UIViewController {
    
    
    var name: String?
    var birthday: String?
    
    var phoneNumber: String?
    var campus: String?

    @IBOutlet weak var campusTxtLbl: UITextField!
    
    var uniName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        campusTxtLbl.becomeFirstResponder()
        createDayPicker()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "moveToEmailVC"{
            if let destination = segue.destination as? emailVC{
                destination.uniName = uniName
                
                destination.birthday = self.birthday
                destination.name = self.name
                destination.phoneNumber = self.phoneNumber
                destination.campus = campus
            }
        }
        
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if uniName != "", uniName != nil {
            
            
            campus = uniName
            self.performSegue(withIdentifier: "moveToEmailVC", sender: nil)
            
        } else {
            
            
            showErrorAlert("Oopps !!!", msg: "Please choose your campus")
            
            
        }
        
        
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
    }

    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func backBtn2Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createDayPicker() {
        
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        //Customizations
        
        
        campusTxtLbl.inputView = dayPicker
        
        
        
        
    }
    
}

extension CampusVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return uniList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return uniList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        
        campusTxtLbl.text = uniList[row]
        uniName = campusTxtLbl.text
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.text = uniList[row]
        uniName = campusTxtLbl.text
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
