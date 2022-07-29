//
//  UIPickerExtension.swift
//  Code Bud
//
//  Created by Atyanta Awesa Pambharu on 26/07/22.
//

import Foundation
import SwiftUI

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: 150)
    }
}
