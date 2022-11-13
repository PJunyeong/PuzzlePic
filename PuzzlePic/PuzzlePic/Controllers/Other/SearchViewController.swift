//
//  SearchViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine
import CombineCocoa
import Lottie

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: nil)
        vc.searchBar.placeholder = "검색..."
        vc.searchBar.searchBarStyle = .minimal
        vc.automaticallyShowsCancelButton = false
        vc.hidesNavigationBarDuringPresentation = false
        return vc
    }()
    private let noSearchResultsView: UILabel = {
        let label = UILabel()
        label.text = "이런! 찾으시는 방이 없습니다.\n다른 이름으로 검색해 보세요."
        label.textAlignment = .center
        label.textColor = UIColor.theme.accent
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.isHidden = true
        return label
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
    private let viewModel: SearchViewModel
    private let failAnimationView: LottieAnimationView = .init(name: "Fail_Animation")
    private let successAnimationView: LottieAnimationView = .init(name: "Success_Animation")
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<PasswordViewController.Input, Never> = .init()
    
    init(dataService: PhotoRoomsSearchDataManager) {
        self.viewModel = SearchViewModel(dataService: dataService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        noSearchResultsView.frame = view.bounds
        noSearchResultsView.center = view.center
        let size = view.frame.width / 3
        successAnimationView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        successAnimationView.center = view.center
        failAnimationView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        failAnimationView.center = view.center
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(noSearchResultsView)
        view.addSubview(failAnimationView)
        view.addSubview(successAnimationView)
        failAnimationView.isHidden = true
        successAnimationView.isHidden = true
        navigationItem.titleView = searchController.searchBar
        navigationItem.backBarButtonItem?.title = ""
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        collectionView.delegate = self
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(popToView), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc private func popToView() {
        navigationController?.popViewController(animated: true)
    }
    
    private func toggleNoSearchResultsView(isHidden: Bool) {
        let inView = isHidden ? collectionView : noSearchResultsView
        let outView = isHidden ? noSearchResultsView : collectionView
        
        UIView.transition(with: inView, duration: 0.5, options: .transitionCrossDissolve) {
            inView.isHidden = false
            outView.isHidden = true
        }
    }
    
    private func bind() {
        viewModel.bind(collectionView: collectionView)
        viewModel
            .allPhotoRoomSearchs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rooms in
                self?.toggleNoSearchResultsView(isHidden: !rooms.isEmpty)
            }
            .store(in: &cancellables)
        searchController
            .searchBar
            .textDidChangePublisher
            .compactMap({ $0 })
            .sink { [weak self] query in
                self?.viewModel.searchText.send(query)
            }
            .store(in: &cancellables)
    }
    
    private func presentPhotoRoomView(model: PhotoRoomSearchModel) {
        let vc = PhotoRoomViewController(model: model)
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = model.title
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func presentPasswordView(model: PhotoRoomSearchModel) {
        let vc = PasswordViewController(model: model)
        vc.delegate = self
        vc.bind(input: input.eraseToAnyPublisher())
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = "이런, 비밀번호를 입력해주세요!"
        navVC.modalPresentationStyle = .pageSheet
        if let sheet = navVC.sheetPresentationController {
            sheet.delegate = self
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
            sheet.detents = [.custom(resolver: { context in
                return 100
            })]
        }
        present(navVC, animated: true)
    }
}

extension SearchViewController: PasswordViewControllerDelegate {
    func passwordDidEntered(_ password: String, _ model: PhotoRoomSearchModel) {
        print("password: \(model.password)")
        if password == model.password {
            successAnimationView.isHidden = false
            successAnimationView.play { [weak self] done in
                if done {
                    self?.successAnimationView.isHidden = true
                    self?.dismiss(animated: true, completion: {
                        self?.presentPhotoRoomView(model: model)
                    })
                }
            }
        } else {
            failAnimationView.isHidden = false
            failAnimationView.play { [weak self] done in
                if done {
                    self?.failAnimationView.isHidden = true
                    self?.input.send(.passwordDidVerified(isPassed: false))
                }
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension SearchViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("sheet dismiss")
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
        let model = viewModel.allPhotoRoomSearchs.value[indexPath.row]
        presentPasswordView(model: model)
    }
}
