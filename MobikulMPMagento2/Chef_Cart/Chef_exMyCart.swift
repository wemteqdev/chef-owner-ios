//
//  Chef_exMyCart.swift
//  MobikulMPMagento2
//
//  Created by Othello on 22/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_exMyCart: UIViewController {
    @IBOutlet weak var aaview:UIView!
    @IBOutlet weak var abview:UIView!
    @IBOutlet weak var baview:UIView!
    @IBOutlet weak var bbview:UIView!
    @IBOutlet weak var caview:UIView!
    @IBOutlet weak var cbview:UIView!
    @IBOutlet weak var daview:UIView!
    @IBOutlet weak var dbview:UIView!
    @IBOutlet weak var aview:UIView!
    @IBOutlet weak var bview:UIView!
    @IBOutlet weak var cview:UIView!
    @IBOutlet weak var dview:UIView!
    @IBOutlet weak var abtn:UIButton!
    @IBOutlet weak var bbtn:UIButton!
    @IBOutlet weak var cbtn:UIButton!
    @IBOutlet weak var dbtn:UIButton!
    @IBOutlet weak var aBrowseButton:UIButton!
    @IBOutlet weak var bBrowseButton:UIButton!
    @IBOutlet weak var cBrowseButton:UIButton!
    @IBOutlet weak var dBrowseButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder(btn:aBrowseButton)
        setBorder(btn:bBrowseButton)
        setBorder(btn:cBrowseButton)
        setBorder(btn:dBrowseButton)
        
        hide(hide: true, a:aaview, b:abview, isani:false, btn:abtn)
        hide(hide: true, a:baview, b:bbview, isani:false, btn:bbtn)
        hide(hide: true, a:caview, b:cbview, isani:false, btn:cbtn)
        hide(hide: true, a:daview, b:dbview, isani:false, btn:dbtn)
        
        var gesture = UITapGestureRecognizer(target: self, action:  #selector (self.aAction (_:)))
        aview.addGestureRecognizer(gesture)
        
        gesture = UITapGestureRecognizer(target: self, action:  #selector (self.bAction (_:)))
        bview.addGestureRecognizer(gesture)
        
        gesture = UITapGestureRecognizer(target: self, action:  #selector (self.cAction (_:)))
        cview.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action:  #selector (self.dAction (_:)))
        dview.addGestureRecognizer(gesture)
    }
    func setBorder(btn: UIButton){
        btn.layer.cornerRadius = aBrowseButton.frame.height / 2 - 2
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor().HexToColor(hexString: "4265A0").cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func hide(hide:Bool, a:UIView, b:UIView, isani:Bool, btn:UIButton) {
        if isani == true {
            UIView.animate(withDuration: 0.3, delay: 0, options: .layoutSubviews, animations: {
                a.isHidden = hide
                b.isHidden = hide
            })
        }
        else {
            a.isHidden = hide
            b.isHidden = hide
        }
        var ximage:UIImage!
        if hide == true{
            ximage = UIImage(named: "ic_down")
        }
        else{
            ximage = UIImage(named: "ic_up")
        }
        btn.setImage(ximage, for: .normal)
        
    }

    @IBAction func A(_ sender: UIButton) {
        hide(hide: !aaview.isHidden, a:aaview, b:abview, isani:true, btn:abtn)
    }
    @IBAction func B(_ sender: UIButton) {
        hide(hide: !baview.isHidden, a:baview, b:bbview, isani:true, btn:bbtn)
    }
    @IBAction func C(_ sender: UIButton) {
        hide(hide: !caview.isHidden, a:caview, b:cbview, isani:true, btn:cbtn)

    }
    @IBAction func D(_ sender: UIButton) {
        hide(hide: !daview.isHidden, a:daview, b:dbview, isani:true, btn:dbtn)
    }
    @objc func aAction(_ sender:UITapGestureRecognizer){
        hide(hide: !aaview.isHidden, a:aaview, b:abview, isani:true, btn:abtn)
    }
 
    @objc func bAction(_ sender:UITapGestureRecognizer){
        
        hide(hide: !baview.isHidden, a:baview, b:bbview, isani:true, btn:bbtn)

    }
    @objc func cAction(_ sender:UITapGestureRecognizer){
        hide(hide: !caview.isHidden, a:caview, b:cbview, isani:true, btn:cbtn)
        
    }
    @objc func dAction(_ sender:UITapGestureRecognizer){
        hide(hide: !daview.isHidden, a:daview, b:dbview, isani:true, btn:dbtn)
    }
   

}
