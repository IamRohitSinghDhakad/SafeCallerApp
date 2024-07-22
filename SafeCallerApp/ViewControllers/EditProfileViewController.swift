//
//  EditProfileViewController.swift
//  SafeCallerApp
//
//  Created by Rohit SIngh Dhakad on 17/07/24.
//

import UIKit
import SDWebImage

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imgVwUser: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        call_getProfileAPI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnUploadImage(_ sender: Any) {
        
        MediaPicker.shared.pickMedia(from: self) { image in
            self.imgVwUser.image = image
            self.pickedImage = image
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnUpdate(_ sender: Any) {
        if validateFields(){
            self.callWebserviceForUpdateProfile()
        }
        
    }
    
    func validateFields() -> Bool {
        
        guard let name = tfFullName.text, !name.isEmpty else {
            // Show an error message for empty password
            objAlert.showAlert(message: "Please Enter Name".localized(), controller: self)
            return false
        }
        
        guard let password = tfPassword.text, !password.isEmpty else {
            // Show an error message for empty password
            objAlert.showAlert(message: "Please Enter Password".localized(), controller: self)
            return false
        }
        
        // All validations pass
        return true
    }
    
}



extension EditProfileViewController{
    
    func callWebserviceForUpdateProfile(){
        
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
            imgData = (self.pickedImage?.jpegData(compressionQuality: 0.2))!
        }
        else {
            imgData = (self.imgVwUser.image?.jpegData(compressionQuality: 0.2))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["user_image"]
        
        let dicrParam = [
            "user_id":objAppShareData.UserDetail.strUser_id,
            "name":self.tfFullName.text!,
            "email":self.tfEmail.text!,
            "password":self.tfPassword.text!
        ]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_UpdateProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                
                guard let user_details  = response["result"] as? [String:Any] else{
                    return
                }
                
                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: "Profile Updated Succesfully", controller: self) {
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
                    
                    self.tfEmail.text = objUser.strEmail
                    self.tfEmail.isUserInteractionEnabled = false
                    self.tfPassword.text = objUser.password
                    self.tfFullName.text = objUser.name
                    
                    let imageUrl  = objUser.user_image
                    if imageUrl != "" {
                        let url = URL(string: imageUrl)
                        self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder_user"))
                    }else{
                        self.imgVwUser.image = #imageLiteral(resourceName: "placeholder_user")
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
