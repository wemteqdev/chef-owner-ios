//
//  CustomAlertViewDelegate.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

protocol AddChefAlertViewDelegate: class {
    func okButtonTapped(textFieldValue: String, restaurantIdValue: Int)
    func cancelButtonTapped()
}
