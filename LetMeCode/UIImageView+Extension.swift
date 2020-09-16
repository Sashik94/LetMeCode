//
//  UIImage+Extension.swift
//  LetMeCode
//
//  Created by Александр Осипов on 16.09.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setShadow(from view: UIView, cornerRadius: Int, color: CGColor = UIColor.black.cgColor) {
        let outerView = view
        outerView.layer.shadowColor = color
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = .init(width: 2, height: 2)
        outerView.layer.shadowRadius = 2
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: CGFloat(cornerRadius)).cgPath
        outerView.layer.shouldRasterize = true
    }
    
    func setCornerRadius(cornerRadius: Int) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
    }
}
