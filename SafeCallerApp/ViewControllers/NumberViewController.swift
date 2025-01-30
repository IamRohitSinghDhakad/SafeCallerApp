//
//  NumberViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 17/07/24.
//

import UIKit
import SDWebImage

class NumberViewController: UIViewController {
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    @IBOutlet weak var txtVwFeedback: RDTextView!
    @IBOutlet var subVw: UIView!
    @IBOutlet weak var imgVwYellow: UIImageView!
    @IBOutlet weak var imgVwGreen: UIImageView!
    @IBOutlet weak var imgVwRed: UIImageView!
    @IBOutlet weak var imgVwTickYellow: UIImageView!
    @IBOutlet weak var imgVwTickgreen: UIImageView!
    @IBOutlet weak var imgVwTickRed: UIImageView!
    @IBOutlet weak var tfArea: UITextField!
    
    
    var arrComments = [CommentsModel]()
    var strMobileNumber = ""
    var strColor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.subVw.isHidden = true
        
        self.lblNumber.text = self.strMobileNumber
        self.lblMobileNumber.text = self.strMobileNumber
        
        let nib = UINib(nibName: "NumberTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "NumberTableViewCell")
        
        resetImages()
        strColor = "Green"
        self.imgVwTickgreen.isHidden = false
        
        self.call_getNumberDetais(strMobileNumber: self.strMobileNumber)
    }
    
    func resetImages(){
        self.imgVwTickYellow.isHidden = true
        self.imgVwTickgreen.isHidden = true
        self.imgVwTickRed.isHidden = true
    }
    
    @IBAction func btnSubmitFeedback(_ sender: Any) {
        
        if self.txtVwFeedback.text == ""{
            objAlert.showAlert(message: "Please enter feedback", controller: self)
        }else{
            self.call_AddComments(strMobileNumber: self.strMobileNumber)
            self.addSubview(isAdd: false)
        }
        
    }
    
    @IBAction func btnCloseSubVw(_ sender: Any) {
        self.addSubview(isAdd: false)
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    
    @IBAction func btnOnLeaveFeedback(_ sender: Any) {
        self.addSubview(isAdd: true)
    }
    
    @IBAction func btnYellow(_ sender: Any) {
        resetImages()
        self.imgVwTickYellow.isHidden = false
        strColor = "Yellow"
    }
    
    @IBAction func btnGreen(_ sender: Any) {
        resetImages()
        self.imgVwTickgreen.isHidden = false
        strColor = "Green"
    }
    
    @IBAction func btnRed(_ sender: Any) {
        resetImages()
        self.imgVwTickRed.isHidden = false
        strColor = "Red"
    }
}

extension NumberViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumberTableViewCell")as! NumberTableViewCell
        
        let obj = self.arrComments[indexPath.row]
        
        cell.lblName.text = obj.strName
        cell.lblDescription.text = obj.strComment
        cell.lblArea.text = obj.strArea
        
        if obj.strColor == "Red"{
            cell.imgVwColor.image = #imageLiteral(resourceName: "red")
        }else if obj.strColor == "Yellow"{
            cell.imgVwColor.image = #imageLiteral(resourceName: "yellow")
        }else{
            cell.imgVwColor.image = #imageLiteral(resourceName: "green 2")
        }
        
        let imageUrl  = obj.strUserImage
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVwLeft.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder_user"))
            cell.imgVwRight.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder_user"))
        }else{
            cell.imgVwLeft.image = #imageLiteral(resourceName: "placeholder_user")
            cell.imgVwRight.image = #imageLiteral(resourceName: "placeholder_user")
        }
        
        if objAppShareData.UserDetail.strUser_id == obj.strUserID{
           // cell.chatbtnHgtCons.constant = 0
            cell.vwContainChat.isHidden = true
        }else{
            //cell.chatbtnHgtCons.constant = 20
            cell.vwContainChat.isHidden = false
        }
        
        if indexPath.row % 2 == 0{
            cell.vwLeft.isHidden = true
            cell.vwRight.isHidden = false
            
        }else{
            cell.vwLeft.isHidden = false
            cell.vwRight.isHidden = true
        }
        
        cell.btnOnChat.tag = indexPath.row
        cell.btnOnChat.addTarget(self, action: #selector(chatButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func chatButtonTapped(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController")as! ChatDetailViewController
        vc.strUserName = self.arrComments[sender.tag].strName ?? ""
        vc.strSenderID = self.arrComments[sender.tag].strUserID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension NumberViewController {
    
    func call_getNumberDetais(strMobileNumber:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["mobile_number":strMobileNumber]as [String:Any]
        
        url = WsUrl.url_get_comments
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    
                    self.arrComments.removeAll()
                    for data in user_details{
                        let obj = CommentsModel(from: data)
                        self.arrComments.append(obj)
                    }
                    
                    self.tblVw.reloadData()
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrComments.removeAll()
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
    
    
    func call_AddComments(strMobileNumber:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id,
                     "mobile_number":strMobileNumber,
                     "comment":self.txtVwFeedback.text!,
                     "color":self.strColor,
                     "area":self.tfArea.text!]as [String:Any]
        
        url = WsUrl.url_add_comment
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    self.call_getNumberDetais(strMobileNumber: self.strMobileNumber)
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrComments.removeAll()
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
    
}


extension NumberViewController{
    
    func addSubview(isAdd: Bool) {
        if isAdd {
            self.subVw.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(subVw)
            
            UIView.animate(withDuration: 0.3) {
                self.subVw.frame.origin.y = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.subVw.frame.origin.y = self.view.frame.height
            } completion: { y in
                self.subVw.removeFromSuperview()
            }
        }
    }
}
