//
//  Chef_Owner_Choice.swift
//  MobikulMPMagento2
//
//  Created by Othello on 13/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_Owner_Choice: UIViewController {
    @IBOutlet weak var chefButton: UIButton!
    @IBOutlet weak var ownerButton: UIButton!
    @IBOutlet weak var baselineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        chefButton.backgroundColor = UIColor(red: 1, green: 1, blue:1, alpha: 0.2)
        chefButton.setTitleColor(UIColor.white, for: .normal)
        chefButton.layer.cornerRadius = 25
        chefButton.layer.masksToBounds = true
        chefButton.layer.borderWidth = 1
        chefButton.layer.borderColor = UIColor.white.cgColor
        
        baselineView.layer.cornerRadius = 2.5
        ownerButton.backgroundColor = UIColor(red: 1, green: 1, blue:1, alpha: 0.2)
        ownerButton.setTitleColor(UIColor.white, for: .normal)
        ownerButton.layer.cornerRadius = 25
        ownerButton.layer.masksToBounds = true
        ownerButton.layer.borderWidth = 1
        ownerButton.layer.borderColor = UIColor.white.cgColor
        
        ownerButton.setTitle(GlobalData.sharedInstance.language(key: "own_owner"), for: .normal)
        
        chefButton.setTitle(GlobalData.sharedInstance.language(key: "own_chef"), for: .normal)
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func chefClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "chef", sender: self)
    }
    @IBAction func ownerClick(_ sender: UIButton){
        self.performSegue(withIdentifier: "chef", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
