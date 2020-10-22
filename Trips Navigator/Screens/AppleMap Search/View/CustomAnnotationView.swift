//
//  CustomAnnotationView.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/21/20.
//

import MapKit
import UIKit

class CustomAnnotationView: MKAnnotationView {

    let animationDuration: TimeInterval = 0.25
    
    weak var calloutView: PlaceDetailView?
    
    override var annotation: MKAnnotation? {
        willSet {
            calloutView?.removeFromSuperview()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = false
        
        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
        mapsButton.setBackgroundImage(UIImage(named: "Map"), for: .normal)
        rightCalloutAccessoryView = mapsButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.calloutView?.removeFromSuperview()
            
            guard let calloutView = UIView.viewFromNibName(PlaceDetailView.reuseIdentifier) as? PlaceDetailView else { return }
            if let placeAnnotation = annotation as? LocalSearchAnnotation {
                var website = String()
                if let url = placeAnnotation.mapItem?.url {
                    website = String(describing: url)
                }
                calloutView.setupUI(withName: placeAnnotation.title ?? "", phoneNumber: placeAnnotation.mapItem?.phoneNumber ?? "", url: website)
            }
            self.addSubview(calloutView)
            calloutView.frame.origin.x = (calloutView.frame.origin.x - (calloutView.frame.width / 2) + (frame.width / 2))
            calloutView.frame.origin.y = (calloutView.frame.origin.y - calloutView.frame.height)
            
            self.calloutView = calloutView
            
            if animated {
                calloutView.alpha = 0
                UIView.animate(withDuration: animationDuration) {
                    calloutView.alpha = 1
                }
            }
        } else {
            guard let calloutView = self.calloutView else { return }
            
            // swiftlint:disable multiline_arguments
            if animated {
                UIView.animate(withDuration: animationDuration) {
                    calloutView.alpha = 0
                } completion: { _ in
                    calloutView.removeFromSuperview()
                }
            } else {
                calloutView.removeFromSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        calloutView?.removeFromSuperview()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) { return hitView }

        if let calloutView = calloutView {
            let pointInCalloutView = convert(point, to: calloutView)
            return calloutView.hitTest(pointInCalloutView, with: event)
        }

        return nil
    }
}
