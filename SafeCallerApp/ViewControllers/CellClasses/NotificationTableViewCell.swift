//
//  NotificationTableViewCell.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 17/07/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
