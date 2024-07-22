//
//  ChatTableViewCell.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 17/07/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwOptions: UIView!
    @IBOutlet weak var btnDeleteChat: UIButton!
    @IBOutlet weak var btnReportUser: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwOptions.isHidden = true
    }
    
    func showOptions() {
          vwOptions.isHidden = false
          vwOptions.alpha = 0.0
          UIView.animate(withDuration: 0.3) {
              self.vwOptions.alpha = 1.0
          }
      }
      
      func hideOptions() {
          UIView.animate(withDuration: 0.3, animations: {
              self.vwOptions.alpha = 0.0
          }) { _ in
              self.vwOptions.isHidden = true
          }
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
