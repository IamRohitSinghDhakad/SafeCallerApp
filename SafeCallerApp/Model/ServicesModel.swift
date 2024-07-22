//
//  GamePlayersModel.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 21/02/24.
//

import UIKit

class ServicesModel: NSObject {
    
  
    var service_name: String?
    var service_image: String?
    var service_id: String?
    var strAddress : String?
    var strContactNumber : String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["service_name"] as? String {
            service_name = value
        }
        
        if let value = dictionary["service_image"] as? String {
            service_image = value
        }
        
        
        if let value = dictionary["address"] as? String {
            strAddress = value
        }
        
        if let value = dictionary["contact_number"] as? String {
            strContactNumber = value
        }
        
        
        
        if let value = dictionary["service_id"] as? String {
            service_id = value
        } else if let value = dictionary["service_id"] as? Int {
            service_id = "\(value)"
        }
    }
    
}

/*
 address = "339 Windermere Rd, London, ON N6A 5A5, Canada";
 "contact_number" = "+1 519-685-8500";
 entrydt = "2024-06-26 09:07:55";
 "service_id" = 1;
 "service_image" = "https://ambitious.in.net/Arun/safecaller/uploads/user/service17193906752661.png";
 "service_name" = "University Hospital";
 status = 1;
 */
