//
//  CustomSlider.swift
//  ARKit-CoreLocation Demo
//
//  Created by Jonah U on 10/6/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSlider: UISlider {

    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(#imageLiteral(resourceName: "thumbImage"), for: .normal)
        }
    }
    
    @IBInspectable var thumbHighlightedImage: UIImage? {
        didSet {
            setThumbImage(#imageLiteral(resourceName: "thumbHighlightedImage"), for: .highlighted)
        }
    }

}
