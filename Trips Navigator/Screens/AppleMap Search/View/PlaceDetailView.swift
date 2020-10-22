//
//  PlaceAnnotationView.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import SafariServices
import UIKit

class PlaceDetailView: UIView, SFSafariViewControllerDelegate {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var callButton: UIButton!
    @IBOutlet private weak var safariButton: UIButton!
    
    private let bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.blue.cgColor
        layer.lineWidth = 0.5
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI(withName name: String, phoneNumber: String, url: String) {
        self.nameLabel.text = name
        self.phoneLabel.text = phoneNumber
        self.urlLabel.text = url
        layer.cornerRadius = 10
        self.nameLabel.layer.cornerRadius = 8
    }
    
    @IBAction private func calButtonTouchUp(_ sender: Any) {

        if let phoneNumber = phoneLabel.text, let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction private func safariButtonTouchUp(_ sender: Any) {
        guard let urlLink = urlLabel.text, let url = URL(string: urlLink) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
