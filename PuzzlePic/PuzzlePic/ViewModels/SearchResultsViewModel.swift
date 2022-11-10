//
//  SearchResultsViewModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import Combine
import UIKit

class SearchResultsViewModel {
    let models: CurrentValueSubject<[PhotoRoomModel], Never> = .init([])
    private var dataSource: UITableViewDiffableDataSource<SearchResultsTableViewSection, PhotoRoomModel>!
    private var cancellables = Set<AnyCancellable>()

    private func updateDateSource(items: [PhotoRoomModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultsTableViewSection, PhotoRoomModel>()
        snapshot.appendSections(SearchResultsTableViewSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func bind(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.identifier, for: indexPath) as? SearchResultsTableViewCell,
                let model = self?.models.value[indexPath.row] else {
                return nil
            }
            cell.configure(with: model)
            return cell
        })
        models
            .sink { [weak self] items in
                self?.updateDateSource(items: items)
            }
            .store(in: &cancellables)
    }
    
    func search(with query: String) {
        
    }
}
