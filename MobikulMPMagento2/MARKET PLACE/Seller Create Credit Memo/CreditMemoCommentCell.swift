//
//  CreditMemoCommentCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 09/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreditMemoCommentCell: UITableViewCell {

    
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    @IBOutlet weak var CommentValue: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentLabel.text = GlobalData.sharedInstance.language(key: "creditmemocomment")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
