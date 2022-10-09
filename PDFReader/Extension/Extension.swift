//
//  Extension.swift
//  PDFReader
//
//  Created by Perennial Macbook on 06/10/22.
//

import Foundation
import UIKit

extension UIView {
    
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x : 0.0, y : 0.5)
        gradient.endPoint = CGPoint(x :1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func addViewBorder(borderColor: CGColor,borderWith: CGFloat,borderCornerRadius:CGFloat){
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = borderCornerRadius
    }
    
    func imageCornerRadius() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        contentMode = .scaleAspectFill
        layer.cornerRadius = 10
        layer.masksToBounds = false
        clipsToBounds = true
    }
}
