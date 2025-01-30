//
//  IAPManager.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 18/07/24.
//

import Foundation
import StoreKit

protocol IAPManagerDelegate: AnyObject {
    func didCompletePurchase(transaction: SKPaymentTransaction)
    func didFailPurchase(error: Error?)
    func didRestorePurchase(transaction: SKPaymentTransaction)
    func didValidateReceipt(success: Bool, message: String)
}

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    var planID: String?
    var isComingFromRestored: Bool?
    var products = [SKProduct]()
    var productIDs: [String] = ["com.ios.SafeCaller_bronze_auto_new","com.ios.SafeCaller_silver_auto_new","com.ios.SafeCaller_gold_auto_new","com.ios.SafeCaller_platinum_auto_new"]
    weak var delegate: IAPManagerDelegate?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
        print("Fetching products...")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in products {
            print("Product found: \(product.productIdentifier) \(product.localizedTitle)")
        }
        if products.isEmpty {
            print("No products found.")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to fetch products: \(error.localizedDescription)")
    }
    
    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                validateReceipt(for: transaction)
                delegate?.didCompletePurchase(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error as NSError? {
                    print("Transaction failed: \(error.localizedDescription)")
                    delegate?.didFailPurchase(error: error)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                validateReceipt(for: transaction)
                delegate?.didRestorePurchase(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func unlockContent(for productIdentifier: String) {
        switch productIdentifier {
        case "com.ios.SafeCaller_bronze_auto_new":
            UserDefaults.standard.set(true, forKey: "bronzePurchased")
        case "com.ios.SafeCaller_silver_auto_new":
            UserDefaults.standard.set(true, forKey: "silverPurchased")
        case "com.ios.SafeCaller_gold_auto_new":
            UserDefaults.standard.set(true, forKey: "goldPurchased")
        case "com.ios.SafeCaller_platinum_auto_new":
            UserDefaults.standard.set(true, forKey: "platinumPurchased")
        default:
            break
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Receipt Handling
    
    func fetchReceiptData() -> Data? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return nil }
        do {
            let receiptData = try Data(contentsOf: receiptURL)
            return receiptData
        } catch {
            print("Error fetching receipt data: \(error)")
            return nil
        }
    }
    
    func validateReceipt(for transaction: SKPaymentTransaction) {
        guard let receiptData = fetchReceiptData() else {
            print("No receipt data found")
            return
        }
        
        guard let planID = self.planID else {
            print("No plan ID set")
            return
        }
        
        // Send the receipt data to your server for validation with the plan ID
        sendReceiptToServer(receiptData: receiptData, planID: planID)
    }

    
    func sendReceiptToServer(receiptData: Data, planID: String) {
        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let receiptString = receiptData.base64EncodedString()
        let requestData: [String: Any] = ["receipt_data": receiptString,
                                          "user_id": objAppShareData.UserDetail.strUser_id,
                                          "plan_id": planID]
        print(requestData)
        
        let url = "https://safecallerapp.com/index.php/api/validate_in_app_purchase_receipt"

        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: requestData, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = response["status"] as? Int
            let message = response["message"] as? String
            print(response)
            if status == MessageConstant.k_StatusCode {
                self.delegate?.didValidateReceipt(success: true, message: "Receipt validation successful.")
            } else {
                self.delegate?.didValidateReceipt(success: false, message: message ?? "Receipt validation failed.")
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            self.delegate?.didValidateReceipt(success: false, message: "Network error or server unavailable.")
        }
    }

    
}
