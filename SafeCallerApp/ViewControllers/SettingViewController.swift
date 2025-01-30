//
//  SettingViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 16/07/24.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    
    var arrMenu = ["Profile", "Subscription", "Contact Us", "Privacy Policy", "Terms & Conditions", "About the App", "Logout", "Delete Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        call_getProfileAPI()
    }

}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell")as! SettingTableViewCell
        
        cell.lblTitle.text = self.arrMenu[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        switch indexPath.row {
        case 0:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController")as! EditProfileViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "MembershipViewController")as! MembershipViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "ContactUsViewController")as! ContactUsViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingFrom = "Privacy Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingFrom = "Terms & Conditions"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingFrom = "About the App"
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "Logout Alert", message: "Are you sure you want to logut?", controller: self) {
                objAppShareData.signOut()
            }
        default:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "Delete Account?", message: "Are you sure you want to delete account?\n this action will erase all your data", controller: self) {
                self.call_DeleteUser()
            }
        }
    }
    
    func call_DeleteUser(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id]as [String:Any]
            
        url = WsUrl.url_delete_user_account
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                objAppShareData.signOut()
                
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                 
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
    
    func call_getProfileAPI(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id]as [String:Any]
            
        url = WsUrl.url_getUserProfile
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                let objUser = UserModel(from: user_details)
                    
                    if objUser.strPlan_id == "0"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController")as! MembershipViewController
                        vc.isComingFrom = "Home"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                       
                    }
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                 
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
