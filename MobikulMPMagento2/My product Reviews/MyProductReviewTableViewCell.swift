//
//  MyProductReviewTableViewCell.swift
//  MobikulMPMagento2
//
//  Created by himanshu on 18/08/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

protocol ProductReviewProtocol {
    func productViewBtnClicked(index: Int)
}

class MyProductReviewTableViewCell: FoldingCells {

    @IBOutlet weak var foreProductImgView: UIImageView!
    @IBOutlet weak var foreProductName : UILabel!
    @IBOutlet weak var foreProductRatingView: HCSStarRatingView!
    
    @IBOutlet weak var backProductImgView: UIImageView!
    @IBOutlet weak var backProductName : UILabel!
    @IBOutlet weak var backProductRatingView: HCSStarRatingView!
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var desc : UILabel!
    @IBOutlet weak var viewBtn : UIButton!
    
    var delegate: ProductReviewProtocol?
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        viewBtn.setTitle(GlobalData.sharedInstance.language(key: "view"), for: .normal)
        viewBtn.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        viewBtn.layer.cornerRadius = 5
        viewBtn.clipsToBounds = true
        foreProductRatingView.tintColor = UIColor().HexToColor(hexString: STAR_COLOR)
        backProductRatingView.tintColor = UIColor().HexToColor(hexString: STAR_COLOR)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCells.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    static var identifier : String  {
        return String(describing: self)
    }
    
    static var nib: UINib   {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var data : MyProductReviewModel? {
        didSet{
            foreProductImgView.image = #imageLiteral(resourceName: "ic_placeholder.png")
            backProductImgView.image = #imageLiteral(resourceName: "ic_placeholder.png")
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: (data?.imageUrl)!, imageView: foreProductImgView)
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: (data?.imageUrl)!, imageView: backProductImgView)
            
            foreProductName.text = data?.productName
            backProductName.text = data?.productName
            
            if (data?.ratingData.count)! > 0{
                let dict = JSON(data?.ratingData[0])
                foreProductRatingView.value = CGFloat(dict["ratingValue"].floatValue / 20)
                backProductRatingView.value = CGFloat(dict["ratingValue"].floatValue / 20)
            }
            
            date.text = data?.date
            desc.text = data?.details
        }
    }
}

// MARK: - Actions ⚡️

extension MyProductReviewTableViewCell {
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
