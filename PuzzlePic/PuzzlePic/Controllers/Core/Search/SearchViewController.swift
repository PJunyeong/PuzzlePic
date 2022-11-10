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
        let results = SearchResultsViewController()
        let vc = UISearchController(searchResultsController: nil)
        vc.searchBar.placeholder = "검색..."
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        vc.hidesNavigationBarDuringPresentation = false
        vc.automaticallyShowsCancelButton = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.becomeFirstResponder()
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
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: nil)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func bind() {
        viewModel.bind(collectionView: collectionView)
        searchController
            .searchBar
            .textDidChangePublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard
                    let resultVC = self?.searchController.searchResultsController as? SearchResultsViewController,
                    !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                resultVC.search(with: query)
            }
            .store(in: &cancellables)
    }
    
    private func cancelButtonDidTap() {
        searchController.searchBar.resignFirstResponder()
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
        let model = viewModel.models.value[indexPath.row]
        let vc = PhotoRoomViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
