//
//  GetGameModel.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 21/02/24.
//

import UIKit

class ChatUsersModel: NSObject {
    
    var name: String?
    var last_message: String?
    var user_id: String?
    var time_ago: String?
    var sender_id: String?
    var receiver_id: String?
    var user_image : String?
   
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["sender_name"] as? String {
            name = value
        }
        
        if let value = dictionary["sender_image"] as? String {
            user_image = value
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        } else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        } else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        } else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
        
        if let value = dictionary["time_ago"] as? String {
            time_ago = value
        }
        
        if let value = dictionary["last_message"] as? String {
            last_message = value
        }
        
        if let value = dictionary["sender_id"] as? String {
            sender_id = value
        }
        
        if let value = dictionary["receiver_id"] as? String {
            receiver_id = value
        }
    }
}
