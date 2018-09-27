//
//  CategorySubcategoryController.swift
//  Kasbee
//
//  Created by kunal prasad on 28/04/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CategorySubcategoryController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var categorySectionData:NSMutableArray!
    public var categorySectionChildData:NSMutableArray!
    public var categorySectionID:NSMutableArray!
    public var categorySectionChildID:NSMutableArray!
    public var selectedCategoryIds:NSMutableArray = [];
    var arrayForBool :NSMutableArray = [];
    
    var assignedCategories : NSMutableArray = NSMutableArray()
    var fromAssignedCategories : Bool = false
    
    //assignedCategories
    //categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(assignedCategories)
        
        if fromAssignedCategories   {
            for _ in 0..<assignedCategories.count{
                arrayForBool.add(Int(0))
            }
        }else{
            for _ in 0..<categorySectionData.count{
                arrayForBool.add(Int(0))
            }
            self.tableView.separatorStyle = .none
            print(categorySectionData)
        }
        
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if fromAssignedCategories   {
            return assignedCategories.count
        }else{
            if (arrayForBool.object(at: section) as! Int) == 1{
                let childArray = categorySectionChildData[section] as! NSMutableArray;
                return childArray.count;
            }else{
                return 0;
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        
        if fromAssignedCategories   {
            
            if let name = (assignedCategories.object(at: indexPath.row) as! NSDictionary).object(forKey: "name") as? String {
                cell.textLabel?.text = name
            }else{
                cell.textLabel?.text = ""
            }
            
            if selectedCategoryIds.contains((assignedCategories.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String) == true {
                cell.accessoryType = .checkmark
            }
            
            cell.selectionStyle = .none
            return cell
        }else{
            let manyCell = arrayForBool.object(at: indexPath.section) as! Int
            
            if manyCell == 0{
                cell.backgroundColor = UIColor.clear
                cell.textLabel?.text = ""
            }else{
                
                let childArray = categorySectionChildData[indexPath.section] as! NSMutableArray
                cell.textLabel?.text = childArray.object(at: indexPath.row) as? String
                
                let childArrayID = categorySectionChildID[indexPath.section] as! NSMutableArray
                if selectedCategoryIds.contains(childArrayID.object(at: indexPath.row)) == true {
                    cell.accessoryType = .checkmark
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if fromAssignedCategories   {
            return 1
        }else{
            return categorySectionData.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if fromAssignedCategories   {
            return 50
        }else{
            let manyCell = arrayForBool.object(at: indexPath.section) as! Int
            if manyCell == 1{
                return 50
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if fromAssignedCategories   {
            return 0
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if fromAssignedCategories   {
            //do nothing
            return UIView()
        }else{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
            headerView.tag = section
            headerView.isUserInteractionEnabled = true
            var X:CGFloat = 5
            let childArray = categorySectionChildData[section] as! NSMutableArray;
            
            if childArray.count > 0{
                
                let button = UIButton(frame: CGRect(x: X, y: 0, width: 50, height: 40))
                button.setTitle("+", for: .normal)
                button.setTitleColor(UIColor.red, for: .normal)
                button.isUserInteractionEnabled = true
                headerView.addSubview(button)
                button.tag = section
                button.addTarget(self, action: #selector(sectionHeader(sender:)), for: .touchUpInside)
                
                X += 50
            }
            
            
            let preLabelAttributes = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(18))!]
            let preLabelStringSize = (categorySectionData.object(at: section) as? String)?.size(withAttributes: preLabelAttributes)
            let label : UILabel = UILabel(frame: CGRect(x: X, y: 0, width: (preLabelStringSize?.width)!, height: 40))
            label.text = categorySectionData.object(at: section) as? String
            label.textColor = UIColor.black
            label.font = UIFont(name: "Trebuchet MS", size: CGFloat(18))!
            label.tag = section
            label.isUserInteractionEnabled = true;
            headerView.addSubview(label)
            
            let radioBtn = UIImageView(frame: CGRect(x: (preLabelStringSize?.width)! + X + 10, y: 5, width: 24, height: 24))
            radioBtn.backgroundColor = UIColor().HexToColor(hexString : "ffffff")
            radioBtn.tag = section
            radioBtn.layer.cornerRadius = 12
            radioBtn.layer.masksToBounds = true
            radioBtn.image = UIImage(named:"")
            radioBtn.layer.borderColor = UIColor.black.cgColor
            radioBtn.layer.borderWidth = 1.0
            radioBtn.isUserInteractionEnabled = true
            headerView.addSubview(radioBtn)
            let addReviewGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectThisOptionRieview))
            addReviewGesture.numberOfTapsRequired = 1
            radioBtn.addGestureRecognizer(addReviewGesture)
            
            let separatorLineView = UIView(frame: CGRect(x: CGFloat(15), y: CGFloat(40), width: CGFloat(tableView.frame.size.width - 15), height: CGFloat(1)))
            separatorLineView.backgroundColor = UIColor.black
            headerView.addSubview(separatorLineView)
            let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.sectionHeaderTapped))
            headerTapped.numberOfTapsRequired = 1;
            headerView.addGestureRecognizer(headerTapped)
            
            if selectedCategoryIds.contains(categorySectionID.object(at: section)) == true {
                radioBtn.image = UIImage(named:"ic_check")
            }
            
            return headerView
        }
    }
    
    @objc func sectionHeader(sender: UIButton){
        var indexPath = IndexPath(row: 0, section: (sender.tag))
        if indexPath.row == 0 {
            var collapsed = (arrayForBool[indexPath.section] as? Int)
            if collapsed == 0{
                collapsed = 1
            }else{
                collapsed = 0
            }
            for i in 0..<categorySectionData.count {
                if indexPath.section == i {
                    arrayForBool[i] = collapsed
                }
            }
            let sectionIndex = IndexSet(integer: (sender.tag))
            tableView.reloadSections(sectionIndex, with: .none)
        }
    }
    
    @objc func selectThisOptionRieview(_ recognizer: UITapGestureRecognizer) {
        let view:UIImageView = recognizer.view as! UIImageView
        if view.image == nil{
            view.image = UIImage(named:"ic_check")
            if selectedCategoryIds.contains(categorySectionID.object(at: (recognizer.view?.tag)!)) == false {
                selectedCategoryIds.add(categorySectionID.object(at: (recognizer.view?.tag)!))
            }
            
        }
        else{
            if selectedCategoryIds.contains(categorySectionID.object(at: (recognizer.view?.tag)!)) == true {
                selectedCategoryIds.removeObject(identicalTo:categorySectionID.object(at: (recognizer.view?.tag)!))
            }
            view.image = UIImage(named:"")
        }
        
        print(selectedCategoryIds)
        
        GlobalVariables.selectedCategoryIds = selectedCategoryIds;
        
    }
    
    @objc func sectionHeaderTapped(_ recognizer: UITapGestureRecognizer) {
        var indexPath = IndexPath(row: 0, section: (recognizer.view?.tag)!)
        if indexPath.row == 0 {
            var collapsed = (arrayForBool[indexPath.section] as? Int)
            if collapsed == 0{
                collapsed = 1
            }else{
                collapsed = 0
            }
            for i in 0..<categorySectionData.count {
                if indexPath.section == i {
                    arrayForBool[i] = collapsed
                }
            }
            let sectionIndex = IndexSet(integer: (recognizer.view?.tag)!)
            tableView.reloadSections(sectionIndex, with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if fromAssignedCategories   {
            var collapsed = (arrayForBool[indexPath.row] as? Int)
            if collapsed == 0{
                collapsed = 1
            }else{
                collapsed = 0
            }
            for i in 0..<assignedCategories.count {
                if indexPath.section == i {
                    arrayForBool[i] = collapsed
                }
            }
            
            if cell?.accessoryType == .checkmark{
                cell?.accessoryType = .none
                if selectedCategoryIds.contains((assignedCategories.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String) == true {
                    selectedCategoryIds.removeObject(identicalTo:(assignedCategories.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String)
                }
                
            }else{
                cell?.accessoryType = .checkmark
                if selectedCategoryIds.contains((assignedCategories.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String) == false {
                    selectedCategoryIds.add((assignedCategories.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as! String)
                }
            }
            
            GlobalVariables.selectedCategoryIds = selectedCategoryIds
            
            let sectionIndex = IndexSet(integer: 0)
            tableView.reloadSections(sectionIndex, with: .none)
        }else{
            let childArray = categorySectionChildID[indexPath.section] as! NSMutableArray
            if cell?.accessoryType == .checkmark{
                cell?.accessoryType = .none
                if selectedCategoryIds.contains(childArray.object(at: indexPath.row)) == true {
                    selectedCategoryIds.removeObject(identicalTo:childArray.object(at: indexPath.row))
                }
                
            }else{
                cell?.accessoryType = .checkmark
                if selectedCategoryIds.contains(childArray.object(at: indexPath.row)) == false {
                    selectedCategoryIds.add(childArray.object(at: indexPath.row))
                }
            }
            
            print(selectedCategoryIds)
            
            GlobalVariables.selectedCategoryIds = selectedCategoryIds
        }
    }
}
