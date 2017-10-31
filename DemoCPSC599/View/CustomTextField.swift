//
//  CustomTextField.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import UIKit


@IBDesignable
class CustomTextField: UITextField, Shakeable {
    
    private var paddingInset: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: self.leftPadding + 30 + 12, bottom: 0, right: 5)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddingInset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddingInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return UIEdgeInsetsInsetRect(bounds, paddingInset)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let img = leftImage {
            leftViewMode = .always
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgView.image = img.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = color
            leftView = imgView
            
        } else {
            leftViewMode = .never
            leftView = nil
        }
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2.0
        layer.masksToBounds = true
    }
    
}



