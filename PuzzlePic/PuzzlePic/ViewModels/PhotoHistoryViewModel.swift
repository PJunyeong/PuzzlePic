//
//  PhotoHistoryViewModel.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/11.
//

import Foundation
import Combine
import UIKit

class PhotoHistoryViewModel {
    let userPhotoRooms: CurrentValueSubject<[PhotoRoomModel], Never> = .init([])
    private let dataService = FirestoreManager.shared
    private var dataSource: UICollectionViewDiffableDataSource<PhotoHistoryCollectionViewSection, PhotoRoomModel>!
    private var cancellables = Set<AnyCancellable>()
    
    private func updateDateSource(items: [PhotoRoomModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<PhotoHistoryCollectionViewSection, PhotoRoomModel>()
        snapshot.appendSections(PhotoHistoryCollectionViewSection.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func bind(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoHistoryCollectionViewCell.identifier, for: indexPath) as? PhotoHistoryCollectionViewCell,
                let model = self?.userPhotoRooms.value[indexPath.row] else { return nil }
            cell.configure(with: model)
            return cell
        })
        dataService
            .userPhotoRooms
            .sink { [weak self] rooms in
                self?.userPhotoRooms.send(rooms)
            }
            .store(in: &cancellables)
        userPhotoRooms
            .sink { [weak self] items in
                self?.updateDateSource(items: items)
            }
            .store(in: &cancellables)
        
    }
}
