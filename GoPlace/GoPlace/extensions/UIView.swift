//
//  UIView.swift
//  GoPlace
//
//  Created by Bruno Aburto on 2/11/21.
//

import UIKit

// MARK: - UI Properties
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor ?? UIColor.clear.cgColor
        }
    }
    
    @IBInspectable var circleView: Bool {
        get {
            return layer.cornerRadius == (frame.width / 2)
        }
        set {
            if(newValue) {
                layer.cornerRadius = frame.width / 2
                layer.masksToBounds = newValue
            }
        }
    }
    
    @IBInspectable var isHidden: Bool {
        get {
            return layer.isHidden
        }
        set {
            layer.isHidden = newValue
        }
    }
    
}

// MARK: - UI Events
extension UIView {
    
    func borderWidthAndColor(_ width: CGFloat, color: UIColor) {
        self.borderWidth = width
        self.borderColor = color
    }
    
}
