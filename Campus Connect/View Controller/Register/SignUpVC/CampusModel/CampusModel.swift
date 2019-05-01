//
//  CampusModel.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/30/19.
//  Copyright © 2019 Campus Connect LLC. All rights reserved.
//

import Foundation
import CoreLocation



class CampusModel {
    
    
    fileprivate var _School_Name: String!
    fileprivate var _Domain: String!
    
    
    
    var School_Name: String! {
        get {
            if _School_Name == nil {
                _School_Name = ""
            }
            return _School_Name
        }
        
    }
    
    var Domain: String! {
        get {
            if _Domain == nil {
                _Domain = ""
            }
            return _Domain
        }
        
    }
    

    
    init(postKey: String, School_model: Dictionary<String, Any>) {
        
        
        print(School_model)
        
        if let School_Name = School_model["School_Name"] as? String {
            self._School_Name = School_Name
            
        }
        
        if let Domain = School_model["Domain"] as? String {
            self._Domain = Domain
            
        }
        
        
        
        
        
    }
    
    
}
