//
//  ContactUsViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 17/07/24.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var txtVwDesc: RDTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        
        if self.tfSubject.text == ""{
            objAlert.showAlert(message: "Please enetr subject", controller: self)
        }else if txtVwDesc.text == ""{
            objAlert.showAlert(message: "Please enetr description", controller: self)
        }else{
            self.call_ContactUS()
        }
    }
}


extension ContactUsViewController{
    
    func call_ContactUS(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id,
                     "subject":self.tfSubject.text!,
                     "message":self.txtVwDesc.text!]as [String:Any]
            
        url = WsUrl.url_ContactUs
        print(dicrParam)
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Request Submiteed", message: "Your message has been sent. We will get back to you shortly.", controller: self) {
                        self.onBackPressed()
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
