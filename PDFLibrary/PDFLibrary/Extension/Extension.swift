//
//  Extension.swift
//  PDFLibrary
//
//  Created by Perennial Macbook on 10/10/22.
//

import Foundation
import UIKit

extension UIView {
    
    public func addViewBorder(borderColor: CGColor,borderWith: CGFloat,borderCornerRadius:CGFloat){
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = borderCornerRadius
    }
}
