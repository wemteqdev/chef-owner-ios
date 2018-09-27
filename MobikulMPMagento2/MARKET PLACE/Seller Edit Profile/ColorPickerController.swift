//
//  ColorPickerController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 26/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController,ChromaColorPickerDelegate {
var colorPicker: ChromaColorPicker!
var delegate:ColorPickerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerSize = CGSize(width: view.bounds.width*0.8, height: view.bounds.width*0.8)
        let pickerOrigin = CGPoint(x: view.bounds.midX - pickerSize.width/2, y: view.bounds.midY - pickerSize.height/2)
        
        /* Create Color Picker */
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.delegate = self
        
        /* Customize the view (optional) */
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float.pi
        
        
        
        /* Customize for grayscale (optional) */
        colorPicker.supportsShadesOfGray = true // false by default
        //colorPicker.colorToggleButton.grayColorGradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor] // You can also override gradient colors
        
        
        colorPicker.hexLabel.textColor = UIColor.black
        
        /* Don't want an element like the shade slider? Just hide it: */
        //colorPicker.shadeSlider.hidden = true
        
        self.view.addSubview(colorPicker)
        
    }

    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        print("sss", colorPicker.hexLabel.text)
        delegate.selectColorsValue(data: colorPicker.hexLabel.text!)
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
