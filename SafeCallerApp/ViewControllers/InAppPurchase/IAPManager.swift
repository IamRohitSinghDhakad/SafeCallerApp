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
}

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    
    var products = [SKProduct]()
    var productIDs: [String] = ["com.ios.SafeCaller_basic", "com.ios.SafeCaller_gold", "com.ios.SafeCaller_platinum"]
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
                unlockContent(for: transaction.payment.productIdentifier)
                delegate?.didCompletePurchase(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error as NSError? {
                    print("Transaction failed: \(error.localizedDescription)")
                    delegate?.didFailPurchase(error: error)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                unlockContent(for: transaction.payment.productIdentifier)
                delegate?.didRestorePurchase(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func unlockContent(for productIdentifier: String) {
        switch productIdentifier {
        case "com.ios.SafeCaller_basic":
            UserDefaults.standard.set(true, forKey: "basicPurchased")
        case "com.ios.SafeCaller_gold":
            UserDefaults.standard.set(true, forKey: "goldPurchased")
        case "com.ios.SafeCaller_platinum":
            UserDefaults.standard.set(true, forKey: "platinumPurchased")
        default:
            break
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
}
