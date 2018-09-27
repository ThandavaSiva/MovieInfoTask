//
//  ViewAditions.swift
//  SampleApp
//
//  Created by admin on 14/08/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func makeCornerRadiusWithValue(_ radius: CGFloat, borderColor: UIColor? = nil) {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
            self.layer.borderWidth = 0.5
        }
    }
}
