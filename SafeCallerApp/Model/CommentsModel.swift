//
//  RegistrationModel.swift
//  FitMate
//
//  Created by Rohit SIngh Dhakad on 17/06/23.
//

import Foundation


class CommentsModel:NSObject{
    
    
    var strName : String?
    var strUserID : String?
    var strComment : String?
    var strColor : String?
    var strArea : String?
    var strUserImage : String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["name"] as? String {
            strName = value
        }
        
        if let value = dictionary["area"] as? String {
            strArea = value
        }
        
        if let value = dictionary["comment"] as? String {
            strComment = value
        }
        
        if let value = dictionary["color"] as? String {
            strColor = value
        }
        
        if let value = dictionary["user_image"] as? String {
            strUserImage = value
        }
        
        if let value = dictionary["user_id"] as? String {
            strUserID = value
        }else if let value = dictionary["user_id"] as? Int {
            strUserID = "\(value)"
        }
    }
}

/*
 address = "";
 color = Red;
 comment = "yshswbe  svdshe e d dshe dbbe rbdhe dbbd dd  ed d dbssjwnsjsje dbzsb s shs sbdbsd sbsbsns 4 ddbdbd  dbdj33n4 3 4 ebe3 bdjd 3 rdjnw ed d e 3r d d ebsjwn3 edjn3 r d ebsbwj2be d siwne d e ed e dbej2 3r j44 r  43 3j3 4 dbwb22brbd 2 3 r 4 w   bdb3nrfn 3 er rn3ne 3  e rr en  4 en 43 3 dene e re d r";
 country = "";
 "device_id" = "";
 "device_token" = "Not found";
 "device_type" = Android;
 dob = "0000-00-00";
 email = "test@gma.com";
 entrydt = "2024-07-16 16:24:06";
 expiry = "2024-07-17 16:24:06";
 gender = "";
 lat = "";
 lng = "";
 mobile = "";
 name = test;
 password = qwerty;
 "plan_id" = 1;
 "plan_txn_id" = "";
 status = 1;
 type = user;
 "user_id" = 20;
 "user_image" = "https://ambitious.in.net/Arun/safecaller/";
},
 */


class MembershipPlanModel:NSObject{
    
    
    var strDescription : String?
    var strCountryID : String?
    var planName : String?
    var planPrice : String?
    var planValidity : String?
    var planID : String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["description"] as? String {
            strDescription = value
        }
        
        if let value = dictionary["name"] as? String {
            planName = value
        }
        
        if let value = dictionary["price"] as? String {
            planPrice = value
        }
        
        if let value = dictionary["validity"] as? String {
            planValidity = value
        }
        
        if let value = dictionary["id"] as? String {
            planID = value
        }else if let value = dictionary["id"] as? Int {
            planID = "\(value)"
        }
    }
}
