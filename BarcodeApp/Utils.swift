//
//  Utils.swift
//  BarcodeApp
//
//  Created by PingLi on 6/9/19.
//  Copyright © 2019 PingLi. All rights reserved.
//

import UIKit

class Utils {
    
    static func callAlertView(title: String, message: String, fromViewController: UIViewController!){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        fromViewController.present(ac, animated: true)
    }
}
