//
//  NotificationModel.swift
//  GMS
//
//  Created by Rohit SIngh Dhakad on 03/12/23.
//

import UIKit

class NotificationModel: NSObject {

    var category_image : String?
    var notificationDescription : String?
    var notificationTitle : String?
    var dateTime : String?
    var notificationId : String?
    var strType : String?
    var articleId : String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["image_url"] as? String {
            category_image = value
        }
        
        if let value = dictionary["notification_title"] as? String {
            notificationTitle = value
        }
        
        if let value = dictionary["notification"] as? String {
            notificationDescription = value
        }
        
        if let value = dictionary["datetime"] as? String {
            dateTime = value
        }
        
        if let value = dictionary["article_type"] as? String {
            strType = value
        }
        
        
        
        if let value = dictionary["notification_id"] as? Int {
            notificationId = "\(value)"
        }else if let value = dictionary["notification_id"] as? String {
            notificationId = value
        }
        
        if let value = dictionary["article_id"] as? Int {
            articleId = "\(value)"
        }else if let value = dictionary["article_id"] as? String {
            articleId = value
        }
    }
}

/*
 {
 "article_id" = 0;
 "article_type" = "";
 datetime = "2023-12-02 20:12:35";
 "deleted_by" = "";
 entrydt = "2023-12-02 20:12:35";
 image = "uploads/notification/17015281557974.jpg";
 "image_url" = "https://ambitious.in.net/Shubham/gms/uploads/notification/17015281557974.jpg";
 notification = "Ovo je test \U0107\U017e\U0111\U0161\U010d\U010d\U017e\U0107";
 "notification_id" = 21;
 "notification_title" = "Notofikacija ios and android 1";
 "send_by" = admin;
 "send_to" = "5,6,7,8,9,10,11,12,13,14,15,16,17,18,19";
 status = 1;
 "time_ago" = "15 hours ago";
 }
 */
