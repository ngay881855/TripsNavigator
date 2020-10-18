//
//  UIApplication+Ext.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/18/20.
//

import Foundation
import UIKit

extension UIApplication {
    func openSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url) { status in
            print("Setting opended \(status)")
        }
    }
}
