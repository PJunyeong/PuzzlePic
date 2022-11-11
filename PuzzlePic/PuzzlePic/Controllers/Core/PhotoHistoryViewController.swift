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
        title = "Photo History"
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchButtonDidTap))
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(settingButtonDidTap))
        navigationItem.rightBarButtonItems = [settingButton, searchButton]
    }
    
    @objc private func searchButtonDidTap() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @objc private func settingButtonDidTap() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
}
