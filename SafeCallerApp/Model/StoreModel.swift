//
//  StoreModel.swift
//  MedicisPizza
//
//  Created by Rohit SIngh Dhakad on 25/10/23.
//

import UIKit

class StoreModel: NSObject {
    
//    var sender_image : String?
    var last_message : String?
    var receiver_id : String?
    var sender_id : String?
    var sender_image : String?
    var sender_name : String?
    var time_ago : String?
    var product_id : String?
    var strBlocked : String = ""
    
    init(from dictionary: [String: Any]) {
        super.init()
        if let sender_name = dictionary["sender_name"] as? String{
            self.sender_name = sender_name
        }
        
        if let sender_image = dictionary["sender_image"] as? String{
            self.sender_image = sender_image
        }
        
        if let last_message = dictionary["last_message"] as? String{
            self.last_message = last_message
        }
        
        if let time_ago = dictionary["time_ago"] as? String{
            self.time_ago = time_ago
        }
        
        if let receiver_id = dictionary["receiver_id"] as? Int{
            self.receiver_id = "\(receiver_id)"
        }else if let receiver_id = dictionary["receiver_id"] as? String{
            self.receiver_id = receiver_id
        }
        
        if let sender_id = dictionary["sender_id"] as? Int{
            self.sender_id = "\(sender_id)"
        }else if let sender_id = dictionary["sender_id"] as? String{
            self.sender_id = sender_id
        }
        
        if let product_id = dictionary["product_id"] as? Int{
            self.product_id = "\(product_id)"
        }else if let product_id = dictionary["product_id"] as? String{
            self.product_id = product_id
        }
        
        if let blocked = dictionary["blocked"] as? String{
            self.strBlocked = blocked
        }else  if let blocked = dictionary["blocked"] as? Int{
            self.strBlocked = "\(blocked)"
        }
        
    }
}

/*
 "category_name" = "<null>";
 "degree_name" = "<null>";
 institute = "<null>";
 "last_image" = "";
 "last_message" = Hi;
 "no_of_message" = 0;
 "product_id" = 1;
 "product_name" = "";
 "receiver_id" = 5;
 "sender_id" = 1;
 "sender_image" = "";
 "sender_name" = "Ambitious Technology";
 "time_ago" = "3 weeks ago";
 */
