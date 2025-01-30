//
//  MembershipViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 18/07/24.
//

import UIKit
import StoreKit

class MembershipViewController: UIViewController, IAPManagerDelegate {
    
    @IBOutlet weak var vwPlatinum: UIView!
    @IBOutlet weak var vwGold: UIView!
    @IBOutlet weak var vwSilver: UIView!
    @IBOutlet weak var vwBronze: UIView!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var vwRestorePurchase: UIView!
    
    var strSeletectdSubscription = ""
    var isComingFrom = ""
    var strPlanID = ""
    var strPurchaseDetails = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.shared.delegate = self
        self.vwRestorePurchase.isHidden = true
    }
    
    @IBAction func btnOnRestorePurchase(_ sender: Any) {
        IAPManager.shared.planID = self.strPlanID
        IAPManager.shared.restorePurchases()
        IAPManager.shared.isComingFromRestored = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchplanId = objAppShareData.UserDetail.strPlan_id
        
        if fetchplanId != "0"{
            self.vwRestorePurchase.isHidden = false
            // self.btnSubscribe.isUserInteractionEnabled = false
            switch fetchplanId {
            case "1":
                self.strPlanID = "1"
                self.vwBronze.backgroundColor = UIColor.black
            case "5":
                self.strPlanID = "5"
                self.vwPlatinum.backgroundColor = UIColor.black
            case "4":
                self.strPlanID = "4"
                self.vwGold.backgroundColor = UIColor.black
            case "3":
                self.strPlanID = "3"
                self.vwSilver.backgroundColor = UIColor.black
            default:
                break
            }
        }
    }
    
    @IBAction func btnOnSubscribe(_ sender: Any) {
        
          if objAppShareData.UserDetail.strPlan_id != "0"{
              objAlert.showAlert(message: "You already have activated plan", controller: self)
         }else{
        switch self.strSeletectdSubscription {
        case "Platinum":
            self.strPlanID = "5"
            purchaseProduct(withIdentifier: "com.ios.SafeCaller_platinum_auto_new")
           
        case "Gold":
            self.strPlanID = "4"
            purchaseProduct(withIdentifier: "com.ios.SafeCaller_gold_auto_new")
           
        case "Silver":
            self.strPlanID = "3"
            purchaseProduct(withIdentifier: "com.ios.SafeCaller_silver_auto_new")
           
        case "Bronze":
            self.strPlanID = "1"
            purchaseProduct(withIdentifier: "com.ios.SafeCaller_bronze_auto_new")
            
        default:
            objAlert.showAlert(message: "Please select subscription plan first", controller: self)
        }
           }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        if self.isComingFrom == "Home"{
            objAppShareData.signOut()
        }else{
            onBackPressed()
        }
        
    }
    
    func resetColor(){
        self.vwGold.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
        self.vwBronze.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
        self.vwSilver.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
        self.vwPlatinum.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
    }
    
    @IBAction func btnSelectPlan(_ sender: UIButton) {
        self.resetColor()
        switch sender.tag {
        case 10:
            self.vwPlatinum.backgroundColor = UIColor.black
            self.strSeletectdSubscription = "Platinum"
        case 11:
            self.vwGold.backgroundColor = UIColor.black
            self.strSeletectdSubscription = "Gold"
        case 12:
            self.vwSilver.backgroundColor = UIColor.black
            self.strSeletectdSubscription = "Silver"
        default:
            self.vwBronze.backgroundColor = UIColor.black
            self.strSeletectdSubscription = "Bronze"
        }
    }
    
    @IBAction func btnOnHelp(_ sender: Any) {
        self.pushVc(viewConterlerId: "ContactUsViewController")
    }
    
    private func purchaseProduct(withIdentifier identifier: String) {
        guard !IAPManager.shared.products.isEmpty else {
            showAlert(title: "Error", message: "Products not loaded. Please try again later.")
            return
        }
        
        guard let product = IAPManager.shared.products.first(where: { $0.productIdentifier == identifier }) else {
            showAlert(title: "Error", message: "Product not found. Please try again later.")
            return
        }
        IAPManager.shared.isComingFromRestored = false
        IAPManager.shared.planID = self.strPlanID
        IAPManager.shared.purchase(product: product)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    // MARK: - IAPManagerDelegate Methods
    func didCompletePurchase(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        let transactionDate = transaction.transactionDate?.description ?? "Unknown Date"
        let transactionID = transaction.transactionIdentifier ?? "Unknown Transaction ID"
        let details = """
           Purchase Details:
           Date: \(String(describing: transactionDate))
           Transaction ID: \(String(describing: transactionID))
           \nPlease login again
           """
        strPurchaseDetails = details
        print(details)
        //  self.call_activateMembership(strDetails: details)
        print(details)
    }
    
    func didFailPurchase(error: Error?) {
        let errorMessage = "Purchase Failed: \(String(describing: error?.localizedDescription))"
        print(errorMessage)
        showAlert(title: "Purchase Failed", message: errorMessage)
        print(errorMessage)
    }
    
    func didRestorePurchase(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        let transactionDate = transaction.transactionDate?.description ?? "Unknown Date"
        let transactionID = transaction.transactionIdentifier ?? "Unknown Transaction ID"

        let details = """
           Purchase Restored Details:
           Date: \(transactionDate)
           Transaction ID: \(transactionID)
           """

        strPurchaseDetails = details
        showAlert(title: "Restore Success", message: details)
        print(details)
    }


    
    func didValidateReceipt(success: Bool, message: String) {
        if success {
            // call_activateMembership(strDetails: "")
            // Handle successful receipt validation
            if IAPManager.shared.isComingFromRestored == true{
                
            }else{
                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Success", message: "Receipt validated successfully. Your subscription is active.\(strPurchaseDetails)", controller: self) {
                    objAppShareData.signOut()
                }
            }
            
        } else {
            // Handle receipt validation failure
            showAlert(title: "Error", message: "Receipt validation failed: \(message)")
        }
    }
    
    
    func call_activateMembership(strDetails:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id,
                     "plan_id":self.strPlanID]as [String:Any]
        
        url = WsUrl.url_ActivateMembership
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Purchase Successful", message: strDetails, controller: self) {
                        objAppShareData.signOut()
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
