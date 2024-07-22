//
//  MembershipViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 18/07/24.
//

import UIKit
import StoreKit

class MembershipViewController: UIViewController, IAPManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        IAPManager.shared.delegate = self
    }
    
    @IBAction func btnOnSubscribe(_ sender: Any) {
        purchaseProduct(withIdentifier: "com.ios.SafeCaller_basic")
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
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
           let transactionDate = transaction.transactionDate
           let transactionID = transaction.transactionIdentifier
           let details = """
           Purchase Successful:
           Product: \(productIdentifier)
           Date: \(String(describing: transactionDate))
           Transaction ID: \(String(describing: transactionID))
           """
           print(details)
           showAlert(title: "Purchase Successful", message: details)
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
           let transactionDate = transaction.transactionDate
           let transactionID = transaction.transactionIdentifier
           let details = """
           Purchase Restored:
           Product: \(productIdentifier)
           Date: \(String(describing: transactionDate))
           Transaction ID: \(String(describing: transactionID))
           """
           print(details)
           showAlert(title: "Purchase Restored", message: details)
           print(details)
       }

}
