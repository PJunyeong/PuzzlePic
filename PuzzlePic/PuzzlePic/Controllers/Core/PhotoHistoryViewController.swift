//
//  PhotoHistoryViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit

class PhotoHistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(searchBarDidTap))
    }
    
    @objc private func searchBarDidTap() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: false)
    }
    
    private func setNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popToView))
    }
    
    @objc private func popToView() {
        navigationController?.popViewController(animated: true)
    }
}
