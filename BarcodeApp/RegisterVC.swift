//
//  RegisterVC.swift
//  BarcodeApp
//
//  Created by PingLi on 6/8/19.
//  Copyright © 2019 PingLi. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class RegisterVC: UIViewController {

    @IBOutlet weak var emialTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onRegisterClicked(_ sender: Any) {
        if passwordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().createUser(withEmail: emialTextField.text!, password: passwordTextField.text!){ (user, error) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if error == nil {
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
