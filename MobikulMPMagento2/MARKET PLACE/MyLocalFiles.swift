//
//  MyLocalFiles.swift
//  Shop767
//
//  Created by Webkul on 23/06/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class MyLocalFiles: UIViewController,UITableViewDelegate, UITableViewDataSource {

@IBOutlet weak var myTableView: UITableView!
var directoryContents :NSArray!
var documentPathUrl:NSURL!
    
    
var storedFiles:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = GlobalData.sharedInstance.language(key: "mystoredfiles")
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
        directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: []) as NSArray
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        for i in 0..<directoryContents.count{
            let fileName = (directoryContents[i] as! NSURL).lastPathComponent
            storedFiles.add(fileName ?? "No File");
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedFiles.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel?.text = storedFiles[indexPath.row] as? String;
        
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let delete = UITableViewRowAction(style: .normal, title: GlobalData.sharedInstance.language(key: "delete")) { action, index in
          let fileManager = FileManager.default
          do {
          try fileManager.removeItem(at: self.directoryContents.object(at: indexPath.row) as! URL)
            
          }catch {
            print("Could not clear temp folder: \(error)")
        }
        self.storedFiles.removeAllObjects()
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            self.directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: []) as NSArray
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        for i in 0..<self.directoryContents.count{
            let fileName = (self.directoryContents[i] as! NSURL).lastPathComponent
            self.storedFiles.add(fileName ?? "No File");
        }
        
        self.myTableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        documentPathUrl = directoryContents.object(at: indexPath.row) as! NSURL
        self.performSegue(withIdentifier: "show", sender: self);
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "show") {
            let viewController:ShowDownloadFile = segue.destination as UIViewController as! ShowDownloadFile
            viewController.documentUrl = documentPathUrl
        }
    }    
}
