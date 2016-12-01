//
//  UIColorExtension.swift
//  Roll and Jump Beta 1
//
//  Created by Administrator on 10/19/14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    //Take the class "UIColor" and add this to it...
    convenience init(hex:Int, alpha:CGFloat = 1.0){
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.00
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
