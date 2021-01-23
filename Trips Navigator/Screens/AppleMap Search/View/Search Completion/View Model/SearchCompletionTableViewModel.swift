//
//  SearchCompletionTableViewModel.swift
//  Trips Navigator
//
//  Created by Ngay Vong on 10/22/20.
//

import Foundation
import MapKit
import UIKit

protocol SearchCompletionTableViewModelProtocol: AnyObject {
    func reloadTableView()
}

class SearchCompletionTableViewModel: NSObject {
    
    weak var delegate: SearchCompletionTableViewModelProtocol?
    
    private var dataSource: [MKLocalSearchCompletion] = []
    
    override init() {
        super.init()
    }

    func loadData(with results: [MKLocalSearchCompletion]) {
        dataSource.removeAll()
        dataSource.append(contentsOf: results)
        self.delegate?.reloadTableView()
    }
    
    func numberOfRow() -> Int {
        return dataSource.count
    }
    
    func cellForRowAt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCompletionTableViewCell.reuseIdentifier) as? SearchCompletionTableViewCell else {
            fatalError("Can not dequeue from tableViewCell")
        }
        let searchResult = dataSource[indexPath.row]
        cell.configureData(searchResult: searchResult)
        
        return cell
    }
}
