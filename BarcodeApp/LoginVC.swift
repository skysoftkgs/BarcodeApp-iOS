//
//  LoginVC.swift
//  BarcodeApp
//
//  Created by PingLi on 6/8/19.
//  Copyright © 2019 PingLi. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLoginClicked(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error == nil{
                let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC")
                UIApplication.shared.keyWindow?.rootViewController = homeVC
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
