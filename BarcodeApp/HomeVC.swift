//
//  HomeVC.swift
//  BarcodeApp
//
//  Created by PingLi on 6/8/19.
//  Copyright © 2019 PingLi. All rights reserved.
//

import UIKit
import BarcodeScanner
import MobileCoreServices

class HomeVC: UIViewController,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{

    private var products = [Product]()
    private var selectedProduct: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = DBManager.sharedInstance.getProducts()
    }
    
    @IBAction func onScanClicked(_ sender: Any) {
//        let viewController = BarcodeScannerViewController()
//        viewController.codeDelegate = self
//        viewController.errorDelegate = self
//        viewController.dismissalDelegate = self
//
//        present(viewController, animated: true, completion: nil)
        
//        addProduct()
//        exportToCSV()
//        importFromCSV()
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(public.csv)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func addProduct(){
//        let name = nameTextField.text ?? ""
//        let phone = phoneTextField.text ?? ""
//        let address = addressTextField.text ?? ""
        let pro = Product()
        pro.title = "kgstitle"
        pro.description = "kgsdescription"
        pro.price = 23.89
        if let id = DBManager.sharedInstance.addProduct(product: pro) {
            products.append(pro)
        
        }
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }

    func importFromCSV(){
        var dataArray : [String] = []
        print(Bundle.main.path(forResource: "barcode_db", ofType: "csv"))
        if  let path = Bundle.main.path(forResource: "barcode_db", ofType: "csv")
        {
            dataArray = []
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let dataEncoded = String(data: data, encoding: .utf8)
                if  let dataArr = dataEncoded?.components(separatedBy: "\r\n").map({ $0.components(separatedBy: ";") })
                {
                    for line in dataArr
                    {
                        dataArray.append("\(line)")
                    }
                }
            }
            catch let jsonErr {
                print("\n Error read CSV file: \n ", jsonErr)
            }
        }
        
        print(dataArray)
    }
    
    func exportToCSV(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let  date = dateFormatter.string(from: Date())
        let fileName = "barcode_db(\(date)).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "\nNo,Title,Description,Price,Vendor,Expiring Date,Encoding Date,Number of Items\n"
        let count = products.count
        if count > 0 {
            
            for i in 0...count-1 {
                let newLine = "\(i+1), \(products[i].title!),\(products[i].description!),\(products[i].price!),\(products[i].vendor!),\(products[i].expiring_date!),\(products[i].encoding_date!),\(products[i].stock_item_count!)\n"
                
                csvText.append(newLine)
            }
            
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
                let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.postToFlickr,
                    UIActivity.ActivityType.postToVimeo,
                    UIActivity.ActivityType.postToTencentWeibo,
                    UIActivity.ActivityType.postToTwitter,
                    UIActivity.ActivityType.postToFacebook,
                    UIActivity.ActivityType.openInIBooks
                ]
                present(vc, animated: true, completion: nil)
                
            } catch {
                
                print("Failed to create file")
                print("\(error)")
            }
            
        } else {
            Utils.callAlertView(title: "Information", message: "There is no data to export", fromViewController: self)
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

// MARK: - BarcodeScannerErrorDelegate

extension HomeVC: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate

extension HomeVC: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - BarcodeScannerCodeDelegate

extension HomeVC: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            controller.resetWithError()
        }
    }
}

