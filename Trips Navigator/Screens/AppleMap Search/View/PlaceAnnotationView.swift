//
//  PlaceAnnotationView.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/19/20.
//

import UIKit

class PlaceAnnotationView: UIView {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    func setupUI(withName name: String, population: Int, score: Double) {
        self.nameLabel.text = name
        self.populationLabel.text = String(population)
        self.scoreLabel.text = String(score)
    }
}
