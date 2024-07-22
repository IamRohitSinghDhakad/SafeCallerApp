//
//  ChatDetailViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 31/05/21.
//

import UIKit
import Alamofire

class ChatDetailViewController: UIViewController,UINavigationControllerDelegate,UIScrollViewDelegate {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var tblChat: UITableView!
    @IBOutlet var txtVwChat: RDTextView!
    @IBOutlet var hgtConsMaximum: NSLayoutConstraint!
    @IBOutlet var hgtConsMinimum: NSLayoutConstraint!
    @IBOutlet var btnSendTextMessage: UIButton!
    @IBOutlet var lblOnLineStatus: UILabel!
    //SUbVw
    @IBOutlet var subVw: UIView!
    @IBOutlet var subVwSelection: UIView!
    @IBOutlet var vwBlockUser: UIView!
    @IBOutlet weak var btnBlockUnblock: UIButton!
    @IBOutlet weak var vwDeleteConversation: UIView!
    @IBOutlet weak var lblBlockMessage: UILabel!
    
    //MARK:- Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34

    var arrChatMessages = [ChatDetailModel]()
    var strUserName = ""
    var strUserImage = ""
    var strSenderID = ""
    var isBlocked = ""
    var timer: Timer?
  
    var isSendMessage = true
    var selectedIndex = -1
    var arrCount = Int()
    var initilizeFirstTimeOnly = Bool()
    var strSelectedImageUrl = ""
    var strMsgID = -1
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.vwBlockUser.isHidden = true
        
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        self.txtVwChat.delegate = self
        
        self.lblUserName.text = strUserName
      
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.tblChat.addGestureRecognizer(longPress)
        
        //self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUser_id, strSenderID: self.strSenderID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.call_GetProfile(strUserID: self.strSenderID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.tblChat.scrollToBottom()
    }
    
    //MARK: - Action Methods
//    @IBAction func btnGoToUserProfile(_ sender: Any) {
//        let userID = self.strSenderID
//        if objAppShareData.UserDetail.strUser_id == userID{
//        }else{
//            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
//            vc?.userID = userID
//            vc?.isComingFromChat = true
//            self.timer?.invalidate()
//            self.timer = nil
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
//    }
    
    
    @IBAction func btnHideSubVwSelection(_ sender: Any) {
        self.subVwSelection.isHidden = true
    }
    

    @IBAction func btnOnBlockAndUnblock(_ sender: Any) {
        if isBlocked == "true"{
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "Unblock User", message: "Are you sure you want to unblock this user?", controller: self) {
                self.call_blockUnblockeUser(strUserID: self.strSenderID)
            }
        }else{
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "Block User", message: "Are you sure you want to block this user?", controller: self) {
                self.call_blockUnblockeUser(strUserID: self.strSenderID)
            }
        }
       
        
    }
    
    @IBAction func btnDeleteFullImageDownload(_ sender: Any) {
        if self.strMsgID != -1{
            
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: "", message: "Do you want to delete this message?", controller: self) {
                let userIDForDelete = self.arrChatMessages[self.strMsgID].strMsgIDForDelete
                self.call_DeleteChatMsgSinle(strUserID: objAppShareData.UserDetail.strUser_id, strMsgID: userIDForDelete)
            }
        }else{
            
        }
    }
    
    
    @objc func updateTimer() {
        //example functionality
        self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUser_id, strSenderID: self.strSenderID)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.timer?.invalidate()
        self.timer = nil
        onBackPressed()
        
    }
   
    
    @IBAction func btnSendMessage(_ sender: Any) {
        if (txtVwChat.text?.isEmpty)!{
            
            self.txtVwChat.text = "."
            self.txtVwChat.text = self.txtVwChat.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtVwChat.isScrollEnabled = false
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            self.txtVwChat.text = ""
            
            if self.txtVwChat.text!.count > 0{
                
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
            
        }else{
            
         
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            DispatchQueue.main.async {
                let text  = self.txtVwChat.text!.encodeEmoji
                self.sendMessageNew(strText: text)
            }
            if self.txtVwChat.text!.count > 0{
                self.txtVwChat.isScrollEnabled = false
                
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }
        
    }
    
    @IBAction func btnOnDeleteChat(_ sender: Any) {
        
        objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "", message: "You want to delete the chat with \(self.strUserName) ?", controller: self) {
            self.timer?.invalidate()
            self.timer = nil
            self.call_ClearConversation(strUserID: objAppShareData.UserDetail.strUser_id)
        }
       // self.tblChat.reloadData()
    }
    
}



//MARK:- UItextViewHeightManage
extension ChatDetailViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 150
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
          if self.txtVwChat.text == "\n"{
              self.txtVwChat.resignFirstResponder()
          }
          else{
          }
          return true
      }
      
    func textViewDidEndEditing(_ textView: UITextView) {
       
    }
      
      func textViewDidChange(_ textView: UITextView)
      {
          if self.txtVwChat.contentSize.height >= self.txtViewCommentMaxHeight
          {
              self.txtVwChat.isScrollEnabled = true
          }
          else
          {
              self.txtVwChat.frame.size.height = self.txtVwChat.contentSize.height
              self.txtVwChat.isScrollEnabled = false
          }
      }
      
    
    
    func sendMessageNew(strText:String){
        self.txtVwChat.isScrollEnabled = false
        self.txtVwChat.contentSize.height = self.txtViewCommentMinHeight
        self.txtVwChat.text = self.txtVwChat.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtVwChat.text == "" {
           // AppSharedClass.shared.showAlert(title: "Alert", message: "Please enter some text", view: self)
            return
        }else{
            self.call_SendTextMessageOnly(strUserID: objAppShareData.UserDetail.strUser_id, strText: strText)
           //asd self.call_WSSendMessage(strSenderID: self.getSenderID, strMessage: self.txtVwChat.text)
        }
        self.txtVwChat.text = ""
    }
    
}


//MARK:- UITableView Delegate and DataSource
extension ChatDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblChat.dequeueReusableCell(withIdentifier: "ChatDetailTVCell")as! ChatDetailTVCell
        
        let obj = self.arrChatMessages[indexPath.row]

            if obj.strSenderId == objAppShareData.UserDetail.strUser_id{
                cell.vwMyMsg.isHidden = false
                cell.lblMyMsg.text = obj.strOpponentChatMessage
                cell.lblMyMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = true
            }else{
                cell.lblOpponentMsg.text = obj.strOpponentChatMessage
                cell.lblopponentMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = false
                cell.vwMyMsg.isHidden = true
            }
//        cell.lblOpponentMsg.text = obj.strOpponentChatMessage
//        cell.lblopponentMsgTime.text = obj.strChatTime
//        cell.lblMyMsgTime.text = obj.strChatTime
//        
       
        
        return cell
    }

    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tblChat)
            if let indexPath = tblChat.indexPathForRow(at: touchPoint) {
                print(indexPath.row)
                // your code here, get the row for the indexPath or do whatever you want
                
                let id = self.arrChatMessages[indexPath.row].strSenderId
                if id == objAppShareData.UserDetail.strUser_id{
                    self.openActionSheet(index: indexPath.row)
                }
            }
        }
    }
    
    
    
    func openActionSheet(index:Int){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Delete message", style: UIAlertAction.Style.default, handler: { (action) -> Void in
         //Delete Message
            
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "", message: "Do you want to delete this message?", controller: self) {
                let msgID = self.arrChatMessages[index].strMsgIDForDelete
                let rec_ID = self.arrChatMessages[index].strReceiverID
                self.call_DeleteChatMsgSinle(strUserID: rec_ID, strMsgID: msgID)
                
            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Copy message", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //Copy Message
            UIPasteboard.general.string = self.arrChatMessages[index].strOpponentChatMessage
            objAlert.showAlert(message: "Copied text", title: "Alert", controller: self)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }

    
    func updateTableContentInset() {
        let numRows = self.tblChat.numberOfRows(inSection: 0)
        var contentInsetTop = self.tblChat.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tblChat.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tblChat.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
}


//Get Chat List
//MARK:- Call Webservice Chat List
extension ChatDetailViewController{
    
    
    //MARK: Block API
    func call_blockUnblockeUser(strUserID: String) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        let parameter = ["blocked_by":objAppShareData.UserDetail.strUser_id,"user_id":strUserID] as [String:Any]
       // let parameter = ["blocked_by":strUserID,"user_id":objAppShareData.UserDetail.strUser_id] as [String:Any]
        
        print(parameter)
        objWebServiceManager.requestPost(strURL: WsUrl.url_BlockUser, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            objWebServiceManager.hideIndicator()
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                   print(user_details)
                    
                    
                    if let unblockedStatus = user_details["unblocked"]as? Int{
                        self.vwBlockUser.isHidden = true
                        self.vwDeleteConversation.isHidden = false
                        self.isBlocked = "false"
                        if self.timer == nil{
                            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                        }else{
                            
                        }
                    }
                    else{
                        self.isBlocked = "true"
                        self.vwBlockUser.isHidden = false
                        self.vwDeleteConversation.isHidden = true
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                    
                   // self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUser_id)
                  
                  
                    
                }
                else {
                    objWebServiceManager.hideIndicator()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    // MARK:- Get Profile
    
    func call_GetProfile(strUserID: String) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
      //  objWebServiceManager.showIndicator()
        
        let parameter = ["user_id" : strUserID, "login_id" : objAppShareData.UserDetail.strUser_id] as [String:Any]
        
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            objWebServiceManager.hideIndicator()
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                   print(user_details)
                    var blockStatus = ""
                    var blockedByMeStatus = ""
                    if let status = user_details["blocked"]as? String{
                        blockStatus = status
                    }else  if let status = user_details["blocked"]as? Int{
                        blockStatus = "\(status)"
                    }
                    
                    if let status = user_details["blockedByYou"]as? String{
                        blockedByMeStatus = status
                    }else  if let status = user_details["blockedByYou"]as? Int{
                        blockedByMeStatus = "\(status)"
                    }
                    
                    print(blockStatus)
                    print(blockedByMeStatus)
                    
                    if blockedByMeStatus == "1"{
                        self.vwBlockUser.isHidden = false
                        self.vwDeleteConversation.isHidden = true
                        self.lblBlockMessage.text = "You have blocked by this user"
                        self.isBlocked = "false"
                    }else if blockStatus == "1"{
                        self.vwBlockUser.isHidden = false
                        self.lblBlockMessage.text = "You blocked this user"
                        self.vwDeleteConversation.isHidden = true
                        self.isBlocked = "true"
                    }else{
                        self.vwBlockUser.isHidden = true
                        self.isBlocked = "false"
                        self.vwDeleteConversation.isHidden = false
                        if self.timer == nil{
                            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                        }else{
                            
                        }
                    }
                    
                }
                else {
                    objWebServiceManager.hideIndicator()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    func call_GetChatList(strUserID:String, strSenderID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
      //  objWebServiceManager.showIndicator()
        
        let parameter = ["receiver_id":strSenderID,
                         "sender_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getChatList, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]] {
                    var newArrayChatMessages: [ChatDetailModel] = []
                    for dict in arrData {
                        let obj = ChatDetailModel.init(dict: dict)
                        newArrayChatMessages.append(obj)
                    }
                    
                    if self.arrChatMessages.count == 0 {
                        //Add initially all
                        self.arrChatMessages.removeAll()
                        self.tblChat.reloadData()
                        
                        for i in 0..<arrData.count{
                            let dictdata = arrData[i]
                            let obj = ChatDetailModel.init(dict: dictdata)
                            self.arrChatMessages.insert(obj, at: i)
    //
    //                        self.arrChatMessages.append(obj)
                            self.tblChat.insertRows(at: [IndexPath(item: i, section: 0)], with: .none)
                        }
                        DispatchQueue.main.async {
                            self.tblChat.scrollToBottom()
                        }
                       
                    }
                    else {
                        let previoudIds = self.arrChatMessages.map { $0.strMsgIDForDelete }
                        let newIds = newArrayChatMessages.map { $0.strMsgIDForDelete }

                        let previoudIdsSet = Set(previoudIds)
                        let newIdsSet = Set(newIds)
                        
                        let unique = (previoudIdsSet.symmetricDifference(newIdsSet)).sorted()
                        
                        for uniqueId in unique {
                            if previoudIds.contains(uniqueId) {
                                //Remove the element
                                if let idToDelete = self.arrChatMessages.firstIndex(where: { $0.strMsgIDForDelete == uniqueId }) {
                                    self.arrChatMessages.remove(at: idToDelete)
                                    self.tblChat.deleteRows(at: [IndexPath(item: idToDelete, section: 0)], with: .none)
                                    
                                }
                            }
                            else if newIds.contains(uniqueId) {
                                // Add new element
                                let filterObj = newArrayChatMessages.filter({ $0.strMsgIDForDelete == uniqueId })
                                if filterObj.count > 0 {
                                    let index = self.arrChatMessages.count
                                    self.arrChatMessages.insert(filterObj[0], at: index)
                                    self.tblChat.insertRows(at: [IndexPath(item: index, section: 0)], with: .none)
                                    self.tblChat.scrollToBottom()
                                }
                                
                            }
                        }
                    }

                    if self.initilizeFirstTimeOnly == false{
                        self.initilizeFirstTimeOnly = true
                        self.arrCount = self.arrChatMessages.count
//                        self.tblChat.reloadData()
                    }
                    
                    if self.arrCount == self.arrChatMessages.count{
                        
                    }else{
//                        self.tblChat.reloadData()
                        self.updateTableContentInset()
                    }
                    
                    
                    if self.arrChatMessages.count == 0{
                        self.tblChat.displayBackgroundText(text: "¡Sin conversación todavía!")
                    }else{
                        self.tblChat.displayBackgroundText(text: "")
                    }
                    
                }
            }else{
               
                    //Add initially all
                    self.arrChatMessages.removeAll()
                    self.tblChat.reloadData()
                
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                   // self.tblChat.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                   // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
 
    
    //MARK:- Send Text message Only
    
    func call_SendTextMessageOnly(strUserID:String, strText:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
       // objWebServiceManager.showIndicator()
        
        let dicrParam = ["receiver_id":self.strSenderID,//Opponent ID
                         "sender_id":strUserID,//My ID
                         "type":"Text",
                         "chat_message":strText]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_insertChat, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if let result = response["result"]as? String{
                if result == "successful"{
                    self.isSendMessage = true
                    self.initilizeFirstTimeOnly = false
                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
                }
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
    //MARK:- Delete Singhe Message
    func call_DeleteChatMsgSinle(strUserID:String, strMsgID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "chat_id":strMsgID]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_deleteChatSingleMessage, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.initilizeFirstTimeOnly = false
                //self.call_GetChatList(strUserID: strUserID, strSenderID: self.strSenderID)
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                   // self.tblChat.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                   // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //MARK:- Delete Singhe Message
    func call_ClearConversation(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["sender_id":strUserID,
                         "receiver_id":strSenderID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_clearConversation, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if (response["result"]as? Int) != nil{
                self.onBackPressed()
            }
            
            if status == MessageConstant.k_StatusCode{
                
               
                
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblChat.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}

//MARK:- CallWebservice
extension ChatDetailViewController{
    
    func callWebserviceForSendImage(strSenderID:String,strReceiverID:String,strType:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
           // imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
            imgData = (self.pickedImage?.pngData())// jpegData(compressionQuality: 1.0))!
        }
        else {
            imgData = (self.imgVwUser.image?.pngData()) //jpegData(compressionQuality: 1.0))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["chat_image"]
        
        print(imageData)
        
        let dicrParam = ["sender_id":strSenderID,
                         "receiver_id":strReceiverID,
                         "chat_message":"",
                         "type":strType
        ]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_insertChat, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "chat_image", mimeType: "image/png") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            
            if let result = response["result"]as? String{
                if result == "successful"{
                    self.subVw.isHidden = true
                    self.subVwSelection.isHidden = true
                    self.isSendMessage = true
                    self.initilizeFirstTimeOnly = false
                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
                }
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
            
        } failure: { (Error) in
            print(Error)
        }
    }
    
   }

//MARK:- Scroll to bottom
extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


extension UIImageView {

 public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

        if self.image == nil{
              self.image = PlaceHolderImage
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
    
}

public extension Sequence {

    func uniq<Id: Hashable >(by getIdentifier: (Iterator.Element) -> Id) -> [Iterator.Element] {
        var ids = Set<Id>()
        return self.reduce([]) { uniqueElements, element in
            if ids.insert(getIdentifier(element)).inserted {
                return uniqueElements + CollectionOfOne(element)
            }
            return uniqueElements
        }
    }


    func uniq<Id: Hashable >(by keyPath: KeyPath<Iterator.Element, Id>) -> [Iterator.Element] {
      return self.uniq(by: { $0[keyPath: keyPath] })
   }
}

public extension Sequence where Iterator.Element: Hashable {

    var uniq: [Iterator.Element] {
        return self.uniq(by: { (element) -> Iterator.Element in
            return element
        })
    }

}


extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}



class ChatDetailTVCell: UITableViewCell {

    @IBOutlet weak var vwOpponent: UIView!
    @IBOutlet weak var vwMyMsg: UIView!
    @IBOutlet weak var lblOpponentMsg: UILabel!
    @IBOutlet weak var lblopponentMsgTime: UILabel!
    @IBOutlet weak var lblMyMsg: UILabel!
    @IBOutlet weak var lblMyMsgTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        let longPressMyMsg = UILongPressGestureRecognizer (target: self, action: #selector (self.longPressMyMessage (gesture :)))
        longPressMyMsg.minimumPressDuration = 1
        self.lblMyMsg.addGestureRecognizer(longPressMyMsg)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @objc func longPressMyMessage (gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print ("longPress began")
        }
        if gesture.state == .ended {
            print ("longPress ended")
        }
    }
    
}
