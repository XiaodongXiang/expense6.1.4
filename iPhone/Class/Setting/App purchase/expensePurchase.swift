//
//  expensePurchase.swift
//  PocketExpense
//
//  Created by 晓东项 on 2018/9/7.
//


import UIKit

class expensePurchase: NSObject {

    override init() {
        
    }
    
    @objc public func request(){
        // Insert your Heroku app URL here.
        let url = URL(string: "https://appxy-iap-verification.herokuapp.com/verify")!
        
        // The Base 64 Encoded public key from Step 1.
        let publicKey = "MIIBCgKCAQEAqQ4zPOh3jZ4SLFWvFeXOhgRn96YY2N8O5zDn5Njdx00YDWF5KgKG/xliqUlwf8uezJZGfE73xMevqKMsDcVjNczU+Ir2+Bs2pilbH3OrjhmaOtWzUy2mMY+p3NTYPtZkFRhYoUi0nZkV3+AKiM6kweUyungmjhipMzysPSvK51Sr/mETpNdKf20drKVP++1fivTGlAyFAWMuiqEEcjd4htxFK1oXZT1C/xfaYt3SABdB9GH1SHIXkAQRjweloHN2OcbOm1ftOoWN3LsHCDNlng26fEGT5J4uEDPnvLjhNde3j8ps9JuKFsFhkabAtfRV1qSNiOFQ0XSuw932EP/mPwIDAQAB"
        
        // Create the receipt verifier from the above values.
        guard let verifier = IAPReceiptVerifier(url: url, base64EncodedPublicKey: publicKey) else {

            return
        }
        
        // Check the app store to see if there is a valid receipt.

        verifier.verify { receipt in
            
//            print(receipt!)
            if receipt != nil{
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnReceipt"), object: receipt)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnReceipt"), object: nil)
            }
//            if receipt != nil {
//                print("---------------------------------------------")
//                print(receipt as Any)
//
//                //            let dataDic:[String:AnyObject] = receipt!["receipt"]! as! [String : AnyObject]
//                //            let dataArr:[AnyObject] = dataDic["in_app"] as! Array
//                //            let data:[String:AnyObject] = (dataArr as Array<Any>).last as! Dictionary
//                let dataArr:[AnyObject] = receipt!["latest_receipt_info"] as! Array
////                print(dataArr)
//
//                var itemDate:Date = Date.init(timeIntervalSince1970: 0)
//                var purchaseDate:Date = Date.init(timeIntervalSince1970: 0)
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
//                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone?
//                var productIdertifer:String?
//
//                for item in dataArr{
//
//                    let expiresDate:String = item["expires_date"] as! String
//                    let purDate:String = item["purchase_date"] as! String
//                    let productID:String = item["product_id"] as! String
//                    //                print("-------------------")
//                    //                print(expiresDate)
//
//                    let end = expiresDate.index(expiresDate.endIndex, offsetBy: -7)
//                    let str = String(expiresDate[..<end])
//                    let dateTime:Date = dateFormatter.date(from: str)!
//
//                    let end2 = purDate.index(expiresDate.endIndex, offsetBy: -7)
//                    let str2 = String(purDate[..<end2])
//                    let datePur:Date = dateFormatter.date(from: str2)!
//
//                    //                print(dateTime)
//
//                    if itemDate.compare(dateTime) == .orderedAscending{
//                        itemDate = dateTime
//                        productIdertifer = productID
//                        purchaseDate = datePur
//
//                    }
//                }
//                print("------------------------//")
//                print(itemDate)
//                print(productIdertifer!)
//                print(purchaseDate)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isNeedToRepurchase"), object: [productIdertifer!:purchaseDate])
//
//                //最新的回执日期超过了现在。说明没过期
//                if itemDate.compare(Date()) == .orderedDescending{
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isNeedToRepurchase"), object: [productIdertifer!:purchaseDate])
//                    //最新的回执日期小于现在，说明过期了
//                }else if itemDate.compare(Date()) == .orderedAscending{
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isNeedToRepurchase"), object: nil)
//
//                }
//            }
        }
    }
    
    @objc public func requestRestore(){
        // Insert your Heroku app URL here.
        let url = URL(string: "https://appxy-iap-verification.herokuapp.com/verify")!
        
        // The Base 64 Encoded public key from Step 1.
        let publicKey = "MIIBCgKCAQEAqQ4zPOh3jZ4SLFWvFeXOhgRn96YY2N8O5zDn5Njdx00YDWF5KgKG/xliqUlwf8uezJZGfE73xMevqKMsDcVjNczU+Ir2+Bs2pilbH3OrjhmaOtWzUy2mMY+p3NTYPtZkFRhYoUi0nZkV3+AKiM6kweUyungmjhipMzysPSvK51Sr/mETpNdKf20drKVP++1fivTGlAyFAWMuiqEEcjd4htxFK1oXZT1C/xfaYt3SABdB9GH1SHIXkAQRjweloHN2OcbOm1ftOoWN3LsHCDNlng26fEGT5J4uEDPnvLjhNde3j8ps9JuKFsFhkabAtfRV1qSNiOFQ0XSuw932EP/mPwIDAQAB"
        
        let indicateView = UIActivityIndicatorView()
        indicateView.startAnimating()
        indicateView.backgroundColor = UIColor.black
        indicateView.activityIndicatorViewStyle = .whiteLarge
        indicateView.layer.cornerRadius = 10;
        indicateView.layer.masksToBounds = true;
        let window = UIApplication.shared.keyWindow!
        indicateView.frame = CGRect.init(x:(UIScreen.main.bounds.size.width-100)/2, y: (UIScreen.main.bounds.size.height-100)/2, width: 100, height: 100)
        window.addSubview(indicateView)

        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + 10.0) {
            DispatchQueue.main.async {
                indicateView.isHidden = true
                indicateView.stopAnimating()
            }
        }
        // Create the receipt verifier from the above values.
        guard let verifier = IAPReceiptVerifier(url: url, base64EncodedPublicKey: publicKey) else {
            DispatchQueue.main.async {
                indicateView.isHidden = true
                indicateView.stopAnimating()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnRestoreReceipt"), object: nil)
            return
        }
        
        // Check the app store to see if there is a valid receipt.
        
        verifier.verify { receipt in
            DispatchQueue.main.async {
                indicateView.isHidden = true
                indicateView.stopAnimating()
            }
//            print("requestRestore")
            if receipt != nil{
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnRestoreReceipt"), object: receipt)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnRestoreReceipt"), object: nil)
            }
        }
    }
    
    
    @objc public func completeTransactionReceipt(){
        // Insert your Heroku app URL here.
        let url = URL(string: "https://appxy-iap-verification.herokuapp.com/verify")!
        
        // The Base 64 Encoded public key from Step 1.
        let publicKey = "MIIBCgKCAQEAqQ4zPOh3jZ4SLFWvFeXOhgRn96YY2N8O5zDn5Njdx00YDWF5KgKG/xliqUlwf8uezJZGfE73xMevqKMsDcVjNczU+Ir2+Bs2pilbH3OrjhmaOtWzUy2mMY+p3NTYPtZkFRhYoUi0nZkV3+AKiM6kweUyungmjhipMzysPSvK51Sr/mETpNdKf20drKVP++1fivTGlAyFAWMuiqEEcjd4htxFK1oXZT1C/xfaYt3SABdB9GH1SHIXkAQRjweloHN2OcbOm1ftOoWN3LsHCDNlng26fEGT5J4uEDPnvLjhNde3j8ps9JuKFsFhkabAtfRV1qSNiOFQ0XSuw932EP/mPwIDAQAB"
        
        // Create the receipt verifier from the above values.
        guard let verifier = IAPReceiptVerifier(url: url, base64EncodedPublicKey: publicKey) else {
            
            return
        }
        
        // Check the app store to see if there is a valid receipt.
        
        verifier.verify { receipt in
            
            //            print(receipt!)
            if receipt != nil{
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"completeTransactionReceipt"), object: receipt)
            }
        }
    }
    
}
