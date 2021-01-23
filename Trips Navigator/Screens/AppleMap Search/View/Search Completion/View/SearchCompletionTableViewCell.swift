//
//  SearchCompletionTableViewCell.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/22/20.
//

import MapKit
import UIKit

class SearchCompletionTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(searchResult: MKLocalSearchCompletion) {
        titleLabel.text = "\(searchResult.title) \(searchResult.subtitle)"
    }
}
