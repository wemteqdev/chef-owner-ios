//
//  DownloadTransactionListController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 08/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class DownloadTransactionListController: UIViewController {

    
    
@IBOutlet weak var transactionId: SkyFloatingLabelTextField!
@IBOutlet weak var fromDatetextFieldf: SkyFloatingLabelTextField!
@IBOutlet weak var toDateTextField: SkyFloatingLabelTextField!
@IBOutlet weak var downloadButton: UIButton!
var documentPathUrl:NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromDatetextFieldf.placeholder = GlobalData.sharedInstance.language(key:"fromdate")
        toDateTextField.placeholder = GlobalData.sharedInstance.language(key:"todate")
        downloadButton.setTitle(GlobalData.sharedInstance.language(key: "submit"), for: .normal)
        downloadButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        transactionId.placeholder = GlobalData.sharedInstance.language(key: "transactionid")
    }

    @IBAction func viewClick(_ sender: Any) {
        self.performSegue(withIdentifier: "myfiles", sender: self)
    }
    
    
    
   
    @IBAction func fromDateClick(_ sender: SkyFloatingLabelTextField) {
    let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        fromDatetextFieldf.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(DownloadTransactionListController.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        fromDatetextFieldf.text = dateFormatter.string(from: sender.date)
    }
    
    
    
    @IBAction func toDateClick(_ sender: SkyFloatingLabelTextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: datePickerView.date)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(DownloadTransactionListController.datePickerToValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    @objc func datePickerToValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        toDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func downloadClick(_ sender: Any) {
        self.download()
    }
    
    func download(){
        
        var fileName:String = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        
        
        let storeId = defaults.object(forKey: "storeId")
        var  url:String = ""
        url = HOST_NAME+"mobikulmphttp/marketplace/downloadTransactionList";
        fileName = "transactionList"+formatter.string(from: date)+".csv"
     
        
        let post = NSMutableString();
        post .appendFormat("storeId=%@&", storeId as! CVarArg);
        post .appendFormat("dateTo=%@&", toDateTextField.text! as CVarArg);
        post .appendFormat("dateFrom=%@&", fromDatetextFieldf.text! as CVarArg);
        post .appendFormat("transactionId=%@", transactionId.text! as CVarArg);
        
        
        self.load(url: URL(string: url)!, params: post as String,name: fileName)
        GlobalData.sharedInstance.showLoader()
        
    }
    
    func load(url: URL, params:String, name:String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = try! URLRequest(url: url, method: .post)
        let postString = params;
        request.httpBody = postString.data(using: .utf8)
        let customerId = defaults.object(forKey:"customerId") as! String;
        request.addValue(customerId, forHTTPHeaderField: "customerToken")
        
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                    GlobalData.sharedInstance.dismissLoader()
                    
                    
                }
                do{
                    let largeImageData = try Data(contentsOf: tempLocalUrl)
                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsDirectoryURL.appendingPathComponent(name);
                    
                    
                    if !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            try largeImageData.write(to: fileURL)
                            let AC = UIAlertController(title:GlobalData.sharedInstance.language(key: "success"), message:GlobalData.sharedInstance.language(key: "filesavemessage"), preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.documentPathUrl = fileURL as NSURL;
                                self.performSegue(withIdentifier: "showFileData", sender: self)
                                
                            })
                            let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            AC.addAction(okBtn)
                            AC.addAction(noBtn)
                            self.present(AC, animated: true, completion: { })
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        print("Image Not Added")
                    }
                    
                    
                    
                    
                }catch{
                    print("error");
                }
                
                
                
                do {
                    
                } catch (let writeError) {
                    
                }
                
            } else {
                GlobalData.sharedInstance.dismissLoader()
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "showFileData") {
            let viewController:ShowDownloadFile = segue.destination as UIViewController as! ShowDownloadFile
            viewController.documentUrl = documentPathUrl
        }
        
    }
    
}
