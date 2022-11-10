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
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
