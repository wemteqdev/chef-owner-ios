//
//  MyDownloads.swift
//  DummySwift
//
//  Created by kunal prasad on 28/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class MyDownloads: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myDownloadTableView: UITableView!
    @IBOutlet weak var myStoreFiles: UIBarButtonItem!
    
    var whichApiToProcess:String!
    var pageNumber:Int = 0
    var reloadPageData:Bool = false
    var loadPageRequestFlag: Bool = false
    var myDownloadsData: NSArray = []
    var indexPathValue:IndexPath!
    var loaderFlag:Bool = false
    var imageCache = NSCache<AnyObject, AnyObject>()
    var totalCount :Int!
    var hashData: String!
    let defaults = UserDefaults.standard;
    var fileName:String!
    var emptyDownloadView:UIView!
    var fileUrl:String!
    var directoryContents:NSArray!
    var documentPathUrl:NSURL!
    var incrementId:String = ""
    let globalObjectMyDownloads = GlobalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: ACCENT_COLOR)
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "mydownload")
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.isNavigationBarHidden = false
        
        myStoreFiles.title = GlobalData.sharedInstance.language(key: "mystoredfiles")
        
        whichApiToProcess = ""
        pageNumber = 1
        totalCount = 0
        loadPageRequestFlag = true;
        self.myDownloadTableView.separatorStyle = .none
        callingHttppApi();
        emptyDownloadView = UIView(frame: CGRect(x:0, y: SCREEN_HEIGHT/2 - 160 , width: SCREEN_WIDTH, height: 170))
        self.view.addSubview(emptyDownloadView)
        let cartImage = UIImageView(frame: CGRect(x:SCREEN_WIDTH/2-60, y:0, width:120, height: 120))
        cartImage.image = UIImage(named: "empty_downloadview")
        emptyDownloadView.addSubview(cartImage)
        let emptyLabel = UILabel(frame: CGRect(x:0, y: 120, width: SCREEN_WIDTH, height: 13))
        emptyLabel.textColor = UIColor.red
        emptyLabel.text = GlobalData.sharedInstance.language(key: "nodownloadproducts")
        emptyLabel.font = UIFont(name: "Helvetica-Bold", size: 13.0)
        emptyLabel.textAlignment = .center
        emptyDownloadView.addSubview(emptyLabel)
        emptyDownloadView.isHidden = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
   
    
    func callingHttppApi(){
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        let customerId = defaults.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if(whichApiToProcess == "getDownloadUrl"){
            requstParams["hash"] = hashData
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/downloadProduct", currentView: self){success,responseObject in
                if success == 1{
                    
                    print("sss", responseObject!)
                    
                    self.doFurtherProcessingWithResult(data: responseObject as! NSDictionary)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            requstParams["pageNumber"] = pageNumber
            
            if(pageNumber == 1){
                GlobalData.sharedInstance.showLoader()
                self.view.isUserInteractionEnabled = false
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/myDownloadsList", currentView: self){success,responseObject in
                if success == 1{
                    print("sss", responseObject!)
                    
                    self.doFurtherProcessingWithResult(data: responseObject as! NSDictionary)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        
        
    }
    
   
    
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true;
            if(self.whichApiToProcess == "getDownloadUrl"){
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    print(data)
                    self.fileUrl = data.object(forKey: "url") as! String
                    self.fileName = data.object(forKey: "fileName") as! String
                    self.startDownloadingData();
                    
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: data.object(forKey: "message") as! String)
                }
            }
            else{
                if(self.reloadPageData == true){
                    let newData:NSArray = (data.object(forKey: "downloadsList") as? NSArray)!;
                    self.myDownloadsData = self.myDownloadsData.addingObjects(from: newData as! [Any]) as NSArray
                    self.loadPageRequestFlag = true
                    if self.myDownloadsData.count == self.totalCount{
                        self.loaderFlag = false;
                    }
                    self.myDownloadTableView.reloadData()
                }
                else{
                    
                    print(data)
                    
                    self.myDownloadsData = data .object(forKey: "downloadsList") as! NSArray!
                    self.totalCount = (data .object(forKey: "totalCount") as! Int!)
                    if self.myDownloadsData.count != self.totalCount{
                        self.loaderFlag = true;
                    }
                    if self.myDownloadsData.count == 0{
                        self.emptyDownloadView.isHidden = false;
                    }else{
                        self.emptyDownloadView.isHidden = true;
                    }
                    
                    self.myDownloadTableView.reloadData()
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if loaderFlag{
            return myDownloadsData.count + 1;
        }else{
            return myDownloadsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        if indexPath.row < myDownloadsData.count{
            let myDownloadDictionaryData = myDownloadsData[indexPath.row] as! NSDictionary;
            
            let date = UILabel(frame: CGRect(x:10, y: 0, width: SCREEN_WIDTH - 20, height: 20))
            date.textColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
            date.textAlignment = .left
            date.font = UIFont(name: REGULARFONT, size: 15.0)
            let dateData = myDownloadDictionaryData.object(forKey: "date") as! String?
            date.text = self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "date", value: "", table: nil) + dateData!
            cell.addSubview(date)
            
            let orderId = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(30), width: SCREEN_WIDTH - 10  , height: CGFloat(20)))
            orderId.textColor =  UIColor(red: 46/255.0, green: 141/255.0, blue: 221/255.0, alpha: 1.0)
            orderId.backgroundColor = UIColor.clear
            orderId.textAlignment = .left
            orderId.font = UIFont(name: REGULARFONT, size: CGFloat(15.0))!
            let orderIdData = myDownloadDictionaryData.object(forKey: "incrementId") as! String?
            let orderIdText = self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "order", value: "", table: nil) + orderIdData!
            orderId.text = orderIdText
            orderId.tag = indexPath.row
            cell.addSubview(orderId)
            let openOrderTap = UITapGestureRecognizer(target: self, action: #selector(self.openOrderDetails))
            openOrderTap.numberOfTapsRequired = 1
            orderId.isUserInteractionEnabled = true
            orderId.addGestureRecognizer(openOrderTap)
            
            
            let title = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(55), width: CGFloat(SCREEN_WIDTH - 86), height: CGFloat(20)))
            title.textColor = UIColor().HexToColor(hexString: ACCENT_COLOR)
            title.textAlignment = .left
            title.backgroundColor = UIColor.clear
            title.font = UIFont(name: REGULARFONT, size: CGFloat(15.0))!
            let titleData = myDownloadDictionaryData.object(forKey: "proName") as! String?
            let titleText = self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "title", value: "", table: nil) + titleData!
            title.text = titleText
            cell.addSubview(title)
            
            let status = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(80), width: CGFloat(SCREEN_WIDTH - 14), height: CGFloat(20)))
            status.textColor = UIColor().HexToColor(hexString: ACCENT_COLOR)
            status.textAlignment = .left
            status.backgroundColor = UIColor.clear
            status.font = UIFont(name: BOLDFONT, size: CGFloat(15.0))!
            let capitalizeText =  myDownloadDictionaryData.object(forKey: "status") as! String?
            let statusText = self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "status", value: "", table: nil) + capitalizeText!
            status.text = statusText
            cell.addSubview(status)
            
            let remainDownload = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(105), width: CGFloat(SCREEN_WIDTH - 14), height: CGFloat(20)))
            remainDownload.textColor = UIColor().HexToColor(hexString: ACCENT_COLOR)
            remainDownload.backgroundColor = UIColor.clear
            remainDownload.textAlignment = .left
            remainDownload.font = UIFont(name: REGULARFONT, size: CGFloat(15.0))!
            let anyData = myDownloadDictionaryData.object(forKey: "remainingDownloads") as AnyObject
            if anyData is String {
                let remainDownloadText = self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "remaindownloads", value: "", table: nil) + (anyData as? String)!
                remainDownload.text = remainDownloadText
            } else {
                let intFormat = (anyData as? Int)!
                let remainDownloadText = self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "remaindownloads", value: "", table: nil) + String(intFormat)
                remainDownload.text = remainDownloadText
            }
            cell.addSubview(remainDownload)
            
            let downloadIcon = UIImageView(frame: CGRect(x: CGFloat(SCREEN_WIDTH - 86), y: CGFloat(25), width: CGFloat(72), height: CGFloat(72)))
            downloadIcon.image = UIImage(named: "ic_download.png")!
            downloadIcon.tag = indexPath.row
            downloadIcon.isUserInteractionEnabled = true
            cell.addSubview(downloadIcon)
            
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.DownloadFile))
            tapGesture1.numberOfTapsRequired = 1
            downloadIcon.addGestureRecognizer(tapGesture1)
            
            
            let lineView2 = UIView(frame: CGRect(x: 5, y: 130, width:SCREEN_WIDTH - 10, height: 2))
            lineView2.backgroundColor = UIColor.black
            cell.addSubview(lineView2)
            
            cell.selectionStyle = .none
            return cell
            
        }
        else{
            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            myActivityIndicator.center = cell.center
            myActivityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            myActivityIndicator.color =  UIColor.black
            myActivityIndicator.startAnimating()
            cell.addSubview(myActivityIndicator)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.myDownloadTableView.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.myDownloadTableView.visibleCells {
            indexPathValue = self.myDownloadTableView.indexPath(for: cell)!
            if indexPathValue.row == self.myDownloadTableView.numberOfRows(inSection: 0) - 1 {
                if (totalCount > currentCellCount) && loadPageRequestFlag{
                    whichApiToProcess = ""
                    reloadPageData = true
                    pageNumber += 1
                    loadPageRequestFlag = false
                    callingHttppApi()
                }
            }
        }}
    
    
    @objc func DownloadFile(_ recognizer: UITapGestureRecognizer) {
        let myDownloadDictionaryData = myDownloadsData[(recognizer.view?.tag)!] as! NSDictionary
        hashData = myDownloadDictionaryData.object(forKey: "hash") as! String
        whichApiToProcess = "getDownloadUrl"
        callingHttppApi()
    }
    
    
    @objc func openOrderDetails(_ recognizer: UITapGestureRecognizer) {
        let myDownloadDictionaryData = myDownloadsData[(recognizer.view?.tag)!] as! NSDictionary
        incrementId = myDownloadDictionaryData.object(forKey: "incrementId") as! String
        self.performSegue(withIdentifier: "customerOrderDetailsSegue", sender: self)
    }
    
    
    func startDownloadingData(){
        do{
            let url = NSURL(string: self.fileUrl)! as URL
            let largeImageData = try Data(contentsOf: url)
            if let bannerImage:UIImage = UIImage(data: largeImageData){
                UIImageWriteToSavedPhotosAlbum(bannerImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            ////////////////////////////////////////  save to document directory ///////////////////////////////////////////
            
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentsDirectoryURL.appendingPathComponent(self.fileName)
            
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try largeImageData.write(to: fileURL)
                    let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "success"), message: GlobalData.sharedInstance.language(key: "filesavemessage"), preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "ok", value: "", table: nil), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        self.documentPathUrl = fileURL as NSURL
                        self.performSegue(withIdentifier:"showFileData" , sender: self)
                    })
                    let noBtn = UIAlertAction(title: self.globalObjectMyDownloads.languageBundle.localizedString(forKey: "cancel", value: "", table: nil), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(okBtn)
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: nil)
                    
                } catch {
                    print(error)
                }
            } else {
                //print("Image Not Added")
            }
        }catch{
            print("error")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            GlobalData.sharedInstance.dismissLoader()
            GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "notloadedtophotodirectory"))
        } else {
            GlobalData.sharedInstance.dismissLoader()
            GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "savedtophotolibrary"))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "showFileData") {
            let viewController:ShowDownloadFile = segue.destination as UIViewController as! ShowDownloadFile
            viewController.documentUrl = documentPathUrl
        }
        else if (segue.identifier! == "customerOrderDetailsSegue"){
            let viewController:CustomerOrderDetails = segue.destination as UIViewController as! CustomerOrderDetails
            viewController.incrementId = self.incrementId;
        }
    }
    
    @IBAction func showStoredFiles(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyLocalFiles") as! MyLocalFiles
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
