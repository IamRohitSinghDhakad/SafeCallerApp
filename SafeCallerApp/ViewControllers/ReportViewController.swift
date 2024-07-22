//
//  ReportViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 19/07/24.
//

import UIKit
import iOSDropDown

class ReportViewController: UIViewController {

    @IBOutlet weak var tfTitle: DropDown!
    @IBOutlet weak var txtVwDes: RDTextView!
    @IBOutlet weak var lblFileName: UILabel!
    
    var arrOptions = ["Nedity or sexual activity", "Hate speech of symbols", "Bullying or harassment", "Scam or fraud", "Intellectual property violation", "Other"]
    var pickedImage:UIImage?
    
    var strUser_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.tfTitle.delegate = self
        self.tfTitle.optionArray = self.arrOptions
        self.tfTitle.didSelect { selectedText, index, id in
            self.tfTitle.text = selectedText
        }
    }
    
    @IBAction func btnOnUpload(_ sender: Any) {
        MediaPicker.shared.pickMedia(from: self) { image in
            self.lblFileName.text = "file uploaded"
            self.pickedImage = image
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnSUbmit(_ sender: Any) {
        self.call_reportUser()
    }

}

extension ReportViewController{
    
    
    func call_reportUser(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
            imgData = (self.pickedImage?.jpegData(compressionQuality: 0.5))!
            imageData.append(imgData!)
        }
        else {
          //  imgData = (self.i.image?.jpegData(compressionQuality: 0.2))!
        }
       
        
        let imageParam = ["image"]
        let dicrParam = [
            "user_id":self.strUser_id,
            "reported_by":objAppShareData.UserDetail.strUser_id,
            "title":self.tfTitle.text!,
            "description":self.txtVwDes.text!]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_ReportUser, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                
                guard let user_details  = response["result"] as? [[String:Any]] else{
                    return
                }
                
                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Thanks for letting us know", message: "Your feedback is important in helping us keep the community safe\n We will get back to you within 24 hours", controller: self) {
                    self.onBackPressed()
                }
                
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: response["result"] as? String ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }

    
}
