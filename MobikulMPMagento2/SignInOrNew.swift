//
//  SignInOrNew.swift
//  MobikulMPMagento2
//
//  Created by Othello on 12/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SignInOrNew: UIViewController {
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var baselineView: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)*/
        
        // Do any additional setup after loading the view.
        signinButton.backgroundColor = UIColor(red: 1, green: 1, blue:1, alpha: 0.2)
        signinButton.setTitleColor(UIColor.white, for: .normal)
        signinButton.layer.cornerRadius = 25
        signinButton.layer.masksToBounds = true
        signinButton.layer.borderWidth = 1
        signinButton.layer.borderColor = UIColor.white.cgColor
        
        baselineView.layer.cornerRadius = 2.5
        
        signupButton.backgroundColor = UIColor(red: 1, green: 1, blue:1, alpha: 0.2)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.layer.cornerRadius = 25
        signupButton.layer.masksToBounds = true
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.white.cgColor
    
        signupButton.setTitle(GlobalData.sharedInstance.language(key: "imnew"), for: .normal)
      
        signinButton.setTitle(GlobalData.sharedInstance.language(key: "login"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signupClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createaccount", sender: self)
    }
    @IBAction func signinClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "customlogin", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }/Volumes/WORK/chef-ios-app/MobikulMPMagento2/SignInOrNew.swift
    */

}
