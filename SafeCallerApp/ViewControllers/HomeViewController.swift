//
//  HomeViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 16/07/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tfNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_getProfileAPI()
    }
    

    @IBAction func btnOnSearch(_ sender: Any) {
        
        if tfNumber.text == ""{
            objAlert.showAlert(message: "Please enter number first", controller: self)
        }else{
            if objAppShareData.UserDetail.strPlan_id == "0"{
                objAlert.showAlert(message: "Please purchase subscription first to use this feature", controller: self)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NumberViewController")as! NumberViewController
                vc.strMobileNumber = self.tfNumber.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
          
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


