//
//  CategoryModel.swift
//  GMS
//
//  Created by Rohit SIngh Dhakad on 16/11/23.
//

import UIKit

class CategoryModel: NSObject {
    
    var category_image : String?
    var category_id : String?
    var selected: String?
    var category_name: String?
    var isSelected:Bool?
    
    var category_icon: String?
    var no_of_players : String?
    var strDate : String?
    var strTime : String?
    /*
     {
     "category_icon" = "uploads/category/121football.png";
     "category_id" = 1;
     "category_image" = "https://ambitious.in.net/Shubham/social-games/uploads/category/284football.png";
     "category_name" = Football;
     entrydt = "2024-01-29 17:54:07";
     "no_of_players" = "https://ambitious.in.net/Shubham/social-games/0";
     position = 1;
     status = 1;
     },
     
     */
    
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["category_id"] as? String {
            category_id = value
        }else if let value = dictionary["category_id"] as? Int {
            category_id = "\(value)"
        }
        
        if let value = dictionary["category_image"] as? String {
            category_image = value
        }
        
        if let value = dictionary["category_name"] as? String {
            category_name = value
        }
        
        if let value = dictionary["entrydt"] as? String {
            strDate = value.formattedDate()
        }
        
        if let value = dictionary["entrydt"] as? String {
            strTime = value.extractTime()
        }
        
        
        
        if let value = dictionary["selected"] as? String {
            selected = value
        }else if let value = dictionary["selected"] as? Int {
            selected = "\(value)"
        }
        
    }
        
}
