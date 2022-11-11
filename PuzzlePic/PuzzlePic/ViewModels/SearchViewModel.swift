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
    let allPhotoRooms: CurrentValueSubject<[PhotoRoomModel], Never> = .init([])
    let searchText: CurrentValueSubject<String, Never> = .init("")
    private let dataService = FirestoreManager.shared
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
                let model = self?.allPhotoRooms.value[indexPath.row] else { return nil }
            cell.configure(with: model)
            return cell
        })
        allPhotoRooms
            .sink { [weak self] items in
                self?.updateDateSource(items: items)
            }
            .store(in: &cancellables)
        searchText
            .combineLatest(dataService.allPhotoRooms)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .map(filterAndSortRooms)
            .sink { [weak self] rooms in
                self?.allPhotoRooms.send(rooms)
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortRooms(query: String, rooms: [PhotoRoomModel]) -> [PhotoRoomModel] {
        let filteredRooms = filterRooms(query: query, rooms: rooms)
        return sortRooms(rooms: filteredRooms)
    }
    
    private func filterRooms(query: String, rooms: [PhotoRoomModel]) -> [PhotoRoomModel] {
        guard !query.isEmpty else { return rooms }
        let lowerCasedQuery = query.lowercased()
        return rooms.filter({ $0.title.lowercased().contains(lowerCasedQuery) && !$0.isCompleted })
    }
    
    private func sortRooms(rooms: [PhotoRoomModel]) -> [PhotoRoomModel] {
        return rooms.sorted { first, second in
            return first.title < second.title
        }
    }

    private func addMockData() {
        var datas = [PhotoRoomModel]()
        let userId = UserDefaultsManager.userId
        for x in 0..<10 {
            let title = "title_\(x)"
            let data = PhotoRoomModel(title: title, createdUserId: userId, password: "", createdDate: "", photoTemplate: "", sideCount: 0, photoModels: [], joinedUserIds: [userId])
            dataService.set(photoRoomModel: data)
        }
    }
}
