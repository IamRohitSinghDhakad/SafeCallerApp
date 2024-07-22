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

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnSearch(_ sender: Any) {
        
        if tfNumber.text == ""{
            objAlert.showAlert(message: "Please enter number first", controller: self)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NumberViewController")as! NumberViewController
            vc.strMobileNumber = self.tfNumber.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
    }

}
