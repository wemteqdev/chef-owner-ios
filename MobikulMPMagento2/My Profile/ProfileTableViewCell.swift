//
//  ProfileTableViewCell.swift
//  Magento2V4Theme
//
//  Created by kunal on 10/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

@IBOutlet weak var profileImage: UIImageView!
@IBOutlet weak var profileName: UILabel!
@IBOutlet weak var profileEmail: UILabel!
@IBOutlet weak var profileBannerImage: UIImageView!
@IBOutlet weak var visualView: UIView!
@IBOutlet var editView: UIVisualEffectView!
var delegate:EditProfiledelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 35;
        profileImage.layer.masksToBounds = true
        editView.layer.cornerRadius = 5;
        editView.layer.masksToBounds = true
        editView.isHidden = true
        visualView.backgroundColor = UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0);
        self.visualView.layer.shadowOpacity = 0;
        var gesture = UITapGestureRecognizer(target: self, action:  #selector (self.saveProfile (_:)))
        editView.addGestureRecognizer(gesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func saveProfile(_ sender:UITapGestureRecognizer){
        delegate.saveProfile();
    }
    
}
