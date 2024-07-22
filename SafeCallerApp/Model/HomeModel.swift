//
//  HomeModel.swift
//  GMS
//
//  Created by Rohit SIngh Dhakad on 17/11/23.
//

import UIKit

class HomeModel: NSObject {
    
    var category_image : String?
    var category_id : String?
    var selected: String?
    var category_name: String?
    var datetime : String?
    var strDescription : String?
    var isLiked : String?
    var strTitle : String?
    var strToTime : String?
    var image1 : String?
    var image2 : String?
    var image3 : String?
    var image4 : String?
    var image5 : String?
    var strType : String?
    var id : String?
    var notification_id : String?
    var strDuration : String?
    
    var eventFromTime : String?
    var eventTotime : String?
    var eventDate : String?
    
    
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["category_id"] as? String {
            category_id = value
        }else if let value = dictionary["category_id"] as? Int {
            category_id = "\(value)"
        }
        
        if let value = dictionary["notification_id"] as? String {
            notification_id = value
        }else if let value = dictionary["notification_id"] as? Int {
            notification_id = "\(value)"
        }
        
        if let value = dictionary["id"] as? String {
            id = value
        }else if let value = dictionary["id"] as? Int {
            id = "\(value)"
        }
        
        if let value = dictionary["category_image"] as? String {
            category_image = value
        }
        
        if let value = dictionary["duration"] as? String {
            strDuration = value
        }
        
        if let value = dictionary["category_name"] as? String {
            category_name = value
        }
        
        if let value = dictionary["selected"] as? String {
            selected = value
        }else if let value = dictionary["selected"] as? Int {
            selected = "\(value)"
        }
        
        if let value = dictionary["datetime"] as? String {
            datetime = value
        }
        
        if let value = dictionary["type"] as? String {
            strType = value
        }
        
        if let value = dictionary["to_time"] as? String {
            strToTime = value
        }
        
        if let value = dictionary["description"] as? String {
            strDescription = value
        }
        
        if let value = dictionary["isLiked"] as? String {
            isLiked = value
        }else if let value = dictionary["isLiked"] as? Int {
            isLiked = "\(value)"
        }
        
        if let value = dictionary["title"] as? String {
            strTitle = value
        }
        
        if let value = dictionary["image1"] as? String {
            image1 = value
        }
        
        if let value = dictionary["image2"] as? String {
            image2 = value
        }
        
        if let value = dictionary["image3"] as? String {
            image3 = value
        }
        
        if let value = dictionary["image4"] as? String {
            image4 = value
        }
        
        if let value = dictionary["image5"] as? String {
            image5 = value
        }
        
        
        //============ EVENT ============//
        
        if let value = dictionary["from_time"] as? String {
            eventFromTime = value
        }
        
        if let value = dictionary["to_time"] as? String {
            eventTotime = value
        }
        
        if let value = dictionary["entrydt"] as? String {
            eventDate = value
        }
        
        //============== XXX ===============//
        
        
    }
    
}
