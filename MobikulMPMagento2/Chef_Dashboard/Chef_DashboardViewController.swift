//
//  Chef_DashboardViewController.swift
//  MobikulMPMagento2
//
//  Created by Othello on 20/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_DashboardViewController: UIViewController {
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var detailBorder: UIView!
    @IBOutlet weak var reviewBorder: UIView!
    @IBOutlet weak var compareBorder: UIView!
    @IBOutlet weak var part1: UIView!
    @IBOutlet weak var part2: UIView!
    @IBOutlet weak var part3: UIView!
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var addCartButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       reviewBorder.isHidden = true
        compareBorder.isHidden = true
        hideReview(isHidden: true)
        compareView.isHidden = true
        // Do any additional setup after loading the view.
    }
    func hideReview(isHidden : Bool){
        part1.isHidden = isHidden
        part2.isHidden = isHidden
        part3.isHidden = isHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func detailButtonClick(_ sender: UIButton){
        reviewBorder.isHidden = true;
        compareBorder.isHidden = true;
        detailBorder.isHidden = false;
        hideReview(isHidden: true)
        compareView.isHidden = true
        addCartButton.isHidden = false
    }
    @IBAction func reviewsButtonClick(_ sender: UIButton){
        reviewBorder.isHidden = false;
        compareBorder.isHidden = true;
        detailBorder.isHidden = true;
        hideReview(isHidden: false)
        compareView.isHidden = true
        addCartButton.isHidden = true
    }
    @IBAction func compareButtonClick(_ sender: UIButton){
        addCartButton.isHidden = true
        reviewBorder.isHidden = true;
        compareBorder.isHidden = false;
        detailBorder.isHidden = true;
        hideReview(isHidden: true)
        compareView.isHidden = false
    }
}
