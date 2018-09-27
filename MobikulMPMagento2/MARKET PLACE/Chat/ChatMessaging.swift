//
//  ChatMessaging.swift
//  MobikulMp
//
//  Created by kunal prasad on 08/02/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseInstanceID
import FirebaseDatabase

class ChatMessaging: UIViewController,UITableViewDelegate,UITableViewDataSource,PHFComposeBarViewDelegate{

@IBOutlet weak var bottomView: UIView!
@IBOutlet weak var tableView: UITableView!
let defaults = UserDefaults.standard;

var bubbleData :NSMutableArray = []
var height:CGFloat = 50;
var keyBoardshownFlag:String = "0";
var ref:DatabaseReference!
var nameArray = [String]()
var textArray = [String]()
var timeArray = [Int64]()
var composeBarView:PHFComposeBarView!
public var customerId:String!
public var token:String!
public var customerName:String!
public var apiKey:String = ""
var sendMessageDict = [String:AnyObject]()
var titleData:String = ""
var message:String = ""

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.separatorStyle = .none
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatMessaging.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationItem.title = customerName
        let isAdmin = defaults.object(forKey:"isAdmin")
        if isAdmin as! String == "t"{
           titleData = "New message from Admin"
        }else{
           titleData = "New message from "+(defaults.object(forKey: "customerName") as? String!)!;
        }
        
        let customerId:String = self.customerId
        ref = Database.database().reference().child(customerId)
        
        ref.observe(.value, with: { snapshot in
            self.textArray.removeAll()
            self.nameArray.removeAll()
            self.timeArray.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        print(postDict)
                        self.nameArray.append(postDict["name"] as! String)
                        self.textArray.append(postDict["msg"] as! String)
                        self.timeArray.append(postDict["timestamp"] as! Int64 )
                    }
                }
            }
            
           self.tableView.reloadData();
            
        })
        
        let viewBounds: CGRect = self.bottomView.bounds
        let frame = CGRect(x: CGFloat(0.0), y: CGFloat(10 ), width: CGFloat(viewBounds.size.width), height: CGFloat(50))
        composeBarView = PHFComposeBarView(frame: frame)
        composeBarView.maxCharCount = 160
        composeBarView.maxLinesCount = 5
        composeBarView.placeholder = "Type something..."
        composeBarView.utilityButtonImage = UIImage(named: "Camera")
        composeBarView.delegate = self
        self.bottomView.addSubview(composeBarView)
        self.bottomView.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            //tableView.contentInsetAdjustmentBehavior = .never
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        let nameData:String = (nameArray[indexPath.row]);
        let messageData:String = textArray[indexPath.row];
        let timeStamp = (timeArray[indexPath.row])
        
        let theDate = NSDate(timeIntervalSince1970: TimeInterval(timeStamp/1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: theDate as Date)
        
        if nameData == "Admin"{
            let description = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(5), width: CGFloat(tableView.frame.size.width - 50), height: CGFloat(20)))
            description.text = "ADMIN \n" + messageData+"\n\n"+dateString
            description.font = UIFont(name: REGULARFONT, size: CGFloat(14.0))
            description.lineBreakMode = .byWordWrapping
            description.numberOfLines = 0
            description.baselineAdjustment = .alignBaselines
            description.textAlignment = .center
            description.preferredMaxLayoutWidth = tableView.frame.size.width/2
            description.sizeToFit()
            height = description.frame.size.height
            
            let bubble = UIImage(named: "bubbleSomeone")?.stretchableImage(withLeftCapWidth: 24, topCapHeight: 15)
            let bubbleView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(2.0), width: CGFloat(description.frame.size.width + 20), height: CGFloat(description.frame.size.height + 20)))
            bubbleView.image = bubble
            
            cell.addSubview(bubbleView);
            
            cell.addSubview(description)
            cell.selectionStyle = .none
            return cell
        }
        else{
            let description = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(5), width: CGFloat(tableView.frame.size.width - 50), height: CGFloat(20)))
            description.text = nameData + "\n" + messageData+"\n\n"+dateString
            description.font = UIFont(name: REGULARFONT, size: CGFloat(14.0))
            description.lineBreakMode = .byWordWrapping
            description.numberOfLines = 0
            description.baselineAdjustment = .alignBaselines
            description.textAlignment = .center
            description.preferredMaxLayoutWidth = tableView.frame.size.width - 50
            description.sizeToFit()
            height = description.frame.size.height
            
            let bubble = UIImage(named: "bubbleMine")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
            let bubbleView = UIImageView(frame: CGRect(x: CGFloat(tableView.frame.size.width - description.frame.size.width - 20), y: CGFloat(2.0), width: CGFloat(description.frame.size.width + 20), height: CGFloat(description.frame.size.height + 20)))
            bubbleView.image = bubble
            bubbleView.addSubview(description);

            cell.addSubview(bubbleView);
            cell.selectionStyle = .none
            return cell
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return height + 20
    }
    
    func composeBarViewDidPressButton(_ composeBarView: PHFComposeBarView) {
        print(composeBarView.text)
 
        let isAdmin = defaults.object(forKey:"isAdmin")
        if isAdmin as! String == "t"{
            sendMessageDict["name"] = "Admin" as AnyObject;
            sendDataToEachSeller(message: composeBarView.text)
        }else{
            sendMessageDict["name"] = customerName as AnyObject;
            message = composeBarView.text;
            callingHttppApi()
        }
        
        sendMessageDict["msg"] = composeBarView.text as AnyObject;
        sendMessageDict["timestamp"] = ServerValue.timestamp() as AnyObject?
        ref.childByAutoId().setValue(sendMessageDict)
        
        composeBarView.setText("", animated: true);
        composeBarView.resignFirstResponder()
  
    }
    
    func sendDataToEachSeller(message:String){
    
        var fullToken:String = token
        let fullTokenArray = fullToken.characters.split{$0 == ","}
        for i in 0..<fullTokenArray.count{
            self.sendToeachdevice(tokenValue: String(fullTokenArray[i]), message: message)
        }
        
    }

    func sendToeachdevice(tokenValue:String , message:String){
        let urlString  = "https://fcm.googleapis.com/fcm/send"
        var request = URLRequest(url: URL(string: urlString)!)
        let token = tokenValue;
        
        let serverkeyData = "key="+apiKey
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(serverkeyData, forHTTPHeaderField: "Authorization")
        
        
        
        let json = [
            "to" : token,
            "priority" : "high",
            "content_available":true,
            "time_to_live":30,
            "delay_while_idle":true,
            "notification" : [
                "body" : message,
                "title": titleData,
                "sound":"default",
                "message":message,
                "id":customerId,
                "name":customerName,
                "notificationType":"chatNotification"
                
            ],
            "data" : [
                "body" : message,
                "title": titleData,
                "sound":"default",
                "message":message,
                "id":customerId,
                "name":customerName,
                "notificationType":"chatNotification"
            ]
            ] as [String : Any]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.httpBody = jsonData
            
            print(json)
            
        }
        catch {
            print(error.localizedDescription)
        }
  
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions()) as (AnyObject)
                
                print("ass",json)
                
                
            } catch {
                print("json error: \(error)")
            }
        }
        task.resume()
        
        
    }
    
    
    
    func callingHttppApi(){
        //GlobalData.sharedInstance.showLoader()
        //self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        requstParams["websiteId"] = "1"
        requstParams["customerToken"] = customerId
        requstParams["sellerName"] = customerName
        requstParams["message"] = message
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/chat/notifyAdmin", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    
                }else{
                    //GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
                
                print("dsd", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    
    


    
 
    
    
    

}
