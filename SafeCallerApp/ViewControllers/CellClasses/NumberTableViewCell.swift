//
//  NumberTableViewCell.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 17/07/24.
//

import UIKit

class NumberTableViewCell: UITableViewCell {

    @IBOutlet weak var vwRight: UIView!
    @IBOutlet weak var vwLeft: UIView!
    @IBOutlet weak var imgVwLeft: UIImageView!
    @IBOutlet weak var imgVwRight: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnOnChat: UIButton!
    @IBOutlet weak var imgVwColor: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var chatbtnHgtCons: NSLayoutConstraint!
    @IBOutlet weak var vwContainChat: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
