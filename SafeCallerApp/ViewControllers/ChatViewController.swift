//
//  ChatViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 16/07/24.
//

import UIKit
import SDWebImage

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    
    
    var arrChatUsers = [ChatUsersModel]()
    var currentOptionsCell: ChatTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_WsGetChatConversation()
    }
    
    
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell")as! ChatTableViewCell
        
        let obj = self.arrChatUsers[indexPath.row]
        
        cell.lblName.text = obj.name
        cell.lblLastMsg.text = obj.last_message
        cell.lblTimeAgo.text = obj.time_ago
        
        let imageUrl  = obj.user_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder_user"))
        }else{
            cell.imgVw.image = #imageLiteral(resourceName: "placeholder_user")
        }
        
        // Add long press gesture to the cell
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        cell.addGestureRecognizer(longPressGesture)
        
        // Add action for cancel button
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(cancelButtonClicked(_:)), for: .touchUpInside)
        
        // Add action for Report button
        cell.btnReportUser.tag = indexPath.row
        cell.btnReportUser.addTarget(self, action: #selector(reportButtonClicked(_:)), for: .touchUpInside)
        
        // Add action for Report button
        cell.btnDeleteChat.tag = indexPath.row
        cell.btnDeleteChat.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController")as! ChatDetailViewController
        vc.strUserName = self.arrChatUsers[indexPath.row].name ?? ""
      //  vc.strUserImage = self.arrChatUsers[indexPath.row].strUserImage
        vc.strSenderID = self.arrChatUsers[indexPath.row].sender_id ?? ""
//        vc.isBlocked = self.arrChatUsers[indexPath.row].strIsBlocked
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
           if gesture.state == .began {
               let touchPoint = gesture.location(in: self.tblVw)
               if let indexPath = tblVw.indexPathForRow(at: touchPoint) {
                   let cell = tblVw.cellForRow(at: indexPath) as! ChatTableViewCell
                   // Hide the currently visible options view if any
                   currentOptionsCell?.hideOptions()
                   // Show the new options view
                   cell.showOptions()
                   // Update the currently visible options cell
                   currentOptionsCell = cell
               }
           }
       }
       
       @objc func cancelButtonClicked(_ sender: UIButton) {
           if let cell = sender.getParentTableViewCell() as? ChatTableViewCell {
               cell.hideOptions()
               // Clear the reference if the current cell's options view is being hidden
               if currentOptionsCell == cell {
                   currentOptionsCell = nil
               }
           }
       }
    
    @objc func reportButtonClicked(_ sender: UIButton) {
        if let cell = sender.getParentTableViewCell() as? ChatTableViewCell {
            cell.hideOptions()
            // Clear the reference if the current cell's options view is being hidden
            if currentOptionsCell == cell {
                currentOptionsCell = nil
            }
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController")as! ReportViewController
        vc.strUser_id = self.arrChatUsers[sender.tag].sender_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteButtonClicked(_ sender: UIButton) {
        if let cell = sender.getParentTableViewCell() as? ChatTableViewCell {
            cell.hideOptions()
            // Clear the reference if the current cell's options view is being hidden
            if currentOptionsCell == cell {
                currentOptionsCell = nil
            }
        }
        self.call_ClearConversation(strSenderID: self.arrChatUsers[sender.tag].sender_id ?? "", strReceiverID: self.arrChatUsers[sender.tag].receiver_id ?? "")
    }
    
    
}

extension UIView {
    func getParentTableViewCell() -> UITableViewCell? {
        var view = self
        while let superview = view.superview {
            if let cell = superview as? UITableViewCell {
                return cell
            }
            view = superview
        }
        return nil
    }
}


extension ChatViewController {
    
    func call_WsGetChatConversation(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id]as [String:Any]
        
        url = WsUrl.url_GetConversation
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    
                    self.arrChatUsers.removeAll()
                    for data in user_details{
                        let obj = ChatUsersModel(from: data)
                        self.arrChatUsers.append(obj)
                    }
                    
                    self.tblVw.reloadData()
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrChatUsers.removeAll()
                    self.tblVw.reloadData()
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
                
                
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Delete Singhe Message
    func call_ClearConversation(strSenderID:String, strReceiverID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["sender_id":strSenderID,
                         "receiver_id":strReceiverID,
                         "delete_conversation":"1"]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_clearConversation, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.call_WsGetChatConversation()
               
                
            }else{
                objWebServiceManager.hideIndicator()
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
