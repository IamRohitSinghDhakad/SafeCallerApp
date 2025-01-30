//
//  SignUpViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 16/07/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imgVwCheckBox: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGoToEULAPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
        vc.isComingFrom = "EULA"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnAcceptCheckbox(_ sender: Any) {
        self.imgVwCheckBox.image = UIImage(systemName: "checkmark.square")
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        if validateFields(){
            self.call_WsSignUp()
        }
       
    }
    
    func validateFields() -> Bool {
        
        guard let name = tfFullName.text, !name.isEmpty else {
            // Show an error message for empty password
            objAlert.showAlert(message: "Please Enter Name".localized(), controller: self)
            return false
        }
        
        guard let email = tfEmail.text, !email.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Please Enter Email".localized(), controller: self)
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard emailPred.evaluate(with: email) else {
            // Show an error message for invalid email format
            objAlert.showAlert(message: "Email is not valid".localized(), controller: self)
            return false
        }
        
        guard let password = tfPassword.text, !password.isEmpty else {
            // Show an error message for empty password
            objAlert.showAlert(message: "Please Enter Password".localized(), controller: self)
            return false
        }
        
        guard self.imgVwCheckBox.image == UIImage(systemName: "checkmark.square") else {
               // Show an error message for not agreeing to the EULA
               objAlert.showAlert(message: "Please Agree to the EULA Terms and Conditions".localized(), controller: self)
               return false
           }
        
        // All validations pass
        return true
    }

}


extension SignUpViewController {
    
    func call_WsSignUp(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
            dicrParam = ["name":self.tfFullName.text!,
                         "email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "device_type":"iOS",
                         "device_token":objAppShareData.strFirebaseToken]as [String:Any]
            
            url = WsUrl.url_SignUp
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestGet(strURL: url, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController")as! MembershipViewController
                    vc.isComingFrom = ""
                    self.navigationController?.pushViewController(vc, animated: true)
                   // self.setRootController()
                    
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
    
    func setRootController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
}
