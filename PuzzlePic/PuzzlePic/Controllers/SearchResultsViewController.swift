//
//  SearchResultsViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine

protocol SearchResultsViewControllerDelegate: AnyObject {
    func photoRoomDidTap(model: PhotoRoomModel)
}

class SearchResultsViewController: UIViewController {
    weak var delegate: SearchResultsViewControllerDelegate?
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.identifier)
        return tableView
    }()
    private var cancellables = Set<AnyCancellable>()
    let viewModel = SearchResultsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        viewModel.bind(tableView: tableView)
    }
    
    func search(with query: String) {
        viewModel.search(with: query)
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.models.value[indexPath.row]
        delegate?.photoRoomDidTap(model: model)
    }
}

