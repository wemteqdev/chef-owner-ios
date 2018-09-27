//
//  RelatedProductController.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 16/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

@objc protocol RelatedProductHandlerDelegate: class {
    func openProduct(productId:String,productName:String,imageUrl:String);
    
}



class RelatedProductController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

@IBOutlet weak var collectionView: UICollectionView!
@IBOutlet weak var viewHeight: NSLayoutConstraint!
var catalogProductViewModel:CatalogProductViewModel!
var productId:String!
var delegate:RelatedProductHandlerDelegate?
let defaults = UserDefaults.standard;
var whichApiToProcess:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewHeight.constant = SCREEN_HEIGHT/2
        let nib = UINib(nibName: "ProductImageCell", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "productimagecell")
        collectionView.delegate = self;
        collectionView.dataSource = self
        collectionView.reloadData()
       
        
    }

 
   
    @IBAction func removeView(_ sender: Any) {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished){
                    self.tabBarController?.tabBar.isHidden = false
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
            });
        }
    
    
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogProductViewModel.getRelatedProducts.count;
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        cell.layer.borderWidth = 0.5
        cell.productImage.image = UIImage(named: "ic_placeholder.png")
        cell.productName.text = catalogProductViewModel.getRelatedProducts[indexPath.row].productName
        cell.productPrice.text = catalogProductViewModel.getRelatedProducts[indexPath.row].price
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: catalogProductViewModel.getRelatedProducts[indexPath.row].imageUrl, imageView: cell.productImage)
        
        
        let Gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.viewProduct))
        Gesture1.numberOfTapsRequired = 1
        cell.productImage.tag = indexPath.row
        cell.productImage.isUserInteractionEnabled = true;
        cell.productImage.addGestureRecognizer(Gesture1)
     
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(self.newProductAddToWishList))
        cell.wishListButton.addGestureRecognizer(tapGesture3)
        
//        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(self.newProductAddToCompare))
//        cell.ic_compare.addGestureRecognizer(tapGesture4)
//
        
        
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width/2, height:collectionView.frame.size.height - 16)
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    @objc func viewProduct(_ recognizer: UITapGestureRecognizer) {
        
  
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.dismiss(animated: true, completion: nil)
                
                
            }
        });
        productId = catalogProductViewModel.getRelatedProducts[(recognizer.view?.tag)!].productId
        let productName = catalogProductViewModel.getRelatedProducts[(recognizer.view?.tag)!].productName
        let imageUrl = catalogProductViewModel.getRelatedProducts[(recognizer.view?.tag)!].imageUrl
        self.delegate?.openProduct(productId: productId!, productName: productName!,imageUrl:imageUrl!);
 
    }

    
    @objc func newProductAddToWishList(_sender : UITapGestureRecognizer){
        let customerId = defaults.object(forKey: "customerId")
        if(customerId == nil){
            let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message:GlobalData.sharedInstance.language(key: "loginrequired"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: { })
        }else{
            
            productId = catalogProductViewModel.getRelatedProducts[(_sender.view?.tag)!].productId;
            whichApiToProcess = "wishlist"
            callingHttppApi()
        }
        
    }
    
    func newProductAddToCompare(_sender : UITapGestureRecognizer){
        productId = catalogProductViewModel.getRelatedProducts[(_sender.view?.tag)!].productId;
        whichApiToProcess = "addtocompare"
        callingHttppApi()
    }

    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        
        var requstParams = [String:Any]();
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        
        if whichApiToProcess == "wishlist"{
            GlobalData.sharedInstance.showLoader()
            let customerId = defaults.object(forKey:"customerId");
            if customerId != nil{
                requstParams["customerToken"] = customerId
            }
            requstParams["productId"] = productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtoWishlist", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successmovetowishlist"))
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "notmovetowishlist"))
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else if whichApiToProcess == "addtocompare"{
            GlobalData.sharedInstance.showLoader()
            let customerId = defaults.object(forKey:"customerId");
            if customerId != nil{
                requstParams["customerToken"] = customerId
            }
            requstParams["productId"] = productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtocompare", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                   
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    print(data)
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }
        
    }
    
    
    
    
}
