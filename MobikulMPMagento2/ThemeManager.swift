//
//  ThemeManager.swift
//  MobikulMagento-2
//
//  Created by kunal on 22/06/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class ThemeManager{
    
    static  func applyTheme(bar:UINavigationBar){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        var frameAndStatusBar: CGRect = bar.bounds
        frameAndStatusBar.size.height += 20
        UINavigationBar.appearance().setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: GRADIENTCOLOR), for: .default)
        UITabBar.appearance().barStyle = .default
        UISwitch.appearance().onTintColor = UIColor().HexToColor(hexString: BUTTON_COLOR).withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        UITabBar.appearance().tintColor =  UIColor().HexToColor(hexString: BUTTON_COLOR)
    }
}

var REDCOLOR = "FF4848"
var ORANGECOLOR = "FF9C05"
var EXTRALIGHTGREY = "ECEFF1"
var LIGHTGREY = "8E8E93"
var ACCENT_COLOR = "29A6F4"
var BUTTON_COLOR = "29A6F4"
var TEXTHEADING_COLOR = "000000"
var NAVIGATION_TINTCOLOR = "29A6F4"
var LINK_COLOR = "000000"
var SHOW_COMPARE = false
var GREEN_COLOR = "05C149"
var STAR_COLOR = "dc831a"
var GRADIENTCOLOR = [UIColor().HexToColor(hexString: ACCENT_COLOR) , UIColor().HexToColor(hexString: BUTTON_COLOR)]
var SELLERGRADIENT = [UIColor().HexToColor(hexString: "29A6F4") , UIColor().HexToColor(hexString: "29A6F4"),UIColor().HexToColor(hexString: "29A6F4")]
var STARGRADIENT = [UIColor().HexToColor(hexString: "29A6F4") , UIColor().HexToColor(hexString: "29A6F4")]


public var BOLDFONT = "Cairo-Bold"
public var REGULARFONT = "Cairo-Regular"
public var ITALICFONT = "Cairo-Italic"
