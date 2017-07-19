//
//  DesignableTextField.swift
//  GGolf
//
//  Created by Miguel Angel on 4/27/17.
//  Copyright © 2017 Thorcode. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {

    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0{
        didSet{
            updateView()
        }
    }
    @IBInspectable var rightPadding: CGFloat = -20 {
        didSet{
            updateView()
        }
    }
    
    private func updateView() {
        if let image = leftImage {
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.tintColor = tintColor
            imageView.alpha = alpha
            
            var width = leftPadding + 20
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                width = width + 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = .never
        }
        
        if let rimage = rightImage {
            rightViewMode = .always
            
            let rigthImageView = UIImageView(frame: CGRect(x: rightPadding, y: 0, width: 20, height: 20))
            rigthImageView.image = rimage
            rigthImageView.tintColor = tintColor
            rigthImageView.alpha = alpha
            
            var width2 = rightPadding - 20
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                width2 = width2 + 5
            }
            let view2 = UIView(frame: CGRect(x: 0, y: 0, width: width2, height: 20))
            view2.addSubview(rigthImageView)
            rightView = view2
        } else {
            rightViewMode = .never
        }
        
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName: tintColor])
        
    }

}
