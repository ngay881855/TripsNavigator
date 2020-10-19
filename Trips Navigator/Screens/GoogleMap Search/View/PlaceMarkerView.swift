//
//  PlaceMarkerView.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import UIKit

class PlaceMarkerView: UIView {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    
    func setupUI(withName name: String, population: String) {
        self.nameLabel.text = name
        self.populationLabel.text = population
    }
}
