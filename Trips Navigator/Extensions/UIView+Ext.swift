//
//  UIView+Ext.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import Foundation
import UIKit

extension UIView {
    class func viewFromNibName(_ name: String) -> UIView? {
      let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
      return views?.first as? UIView
    }
}
