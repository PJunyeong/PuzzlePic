//
//  SearchViewModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import Combine
import UIKit

class SearchViewModel {
    let models: CurrentValueSubject<[PhotoRoomModel], Never> = .init([])
    private var dataSource: UICollectionViewDiffableDataSource<SearchCollectionViewSection, PhotoRoomModel>!
    private var cancellables = Set<AnyCancellable>()
    
    private func updateDateSource(items: [PhotoRoomModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchCollectionViewSection, PhotoRoomModel>()
        snapshot.appendSections(SearchCollectionViewSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func bind(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell,
                let model = self?.models.value[indexPath.row] else { return nil }
            cell.configure(with: model)
            return cell
        })
        
        models
            .sink { [weak self] items in
                print("Update!")
                self?.updateDateSource(items: items)
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.addMockData()
        }
    }
    
    private func addMockData() {
        var datas = [PhotoRoomModel]()
        for x in 0..<100 {
            let title = "title_\(x)"
            let data = PhotoRoomModel(title: title, createdUserId: "", password: "", createdDate: "", photoTemplate: "", sideCount: 0, photoModels: [])
            datas.append(data)
        }
        models.send(datas)
    }
}
