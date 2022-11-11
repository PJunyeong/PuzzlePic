//
//  SearchViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine
import CombineCocoa

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: nil)
        vc.searchBar.placeholder = "검색..."
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        vc.automaticallyShowsCancelButton = false
        vc.hidesNavigationBarDuringPresentation = false
        return vc
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return collectionView
    }()
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        navigationItem.titleView = searchController.searchBar
        searchController.searchResultsUpdater = self
        collectionView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popToView))
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc private func popToView() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bind() {
        viewModel.bind(collectionView: collectionView)
        searchController
            .searchBar
            .textDidChangePublisher
            .compactMap({ $0 })
            .sink { [weak self] query in
                self?.viewModel.searchText.send(query)
            }
            .store(in: &cancellables)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults called")
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 2
        return CGSize(width: width, height: width)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.allPhotoRooms.value[indexPath.row]
        let vc = PhotoRoomViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}