//
//  AlertHandlerProtocol.swift
//  Location_demo
//
//  Created by Ngay Vong on 10/14/20.
//

import Foundation
import UIKit

enum AlertButton: String {
    case cancel
    case settings
}

protocol AlertHandlerProtocol: UIViewController {
    func showAlert(title: String, message: String, buttons: [AlertButton], completion: @escaping (UIAlertController, AlertButton) -> Void)
}

extension AlertHandlerProtocol {
    func showAlert(title: String, message: String, buttons: [AlertButton] = [.cancel], completion: @escaping (UIAlertController, AlertButton) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach { button in
            let action = UIAlertAction(title: button.rawValue.capitalized, style: .default) { _ in
                completion(alert, button)
            }
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: AlertHandlerProtocol { }
