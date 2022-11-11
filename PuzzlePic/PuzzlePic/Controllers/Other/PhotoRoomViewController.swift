//
//  PhotoViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit
import Combine
import CombineCocoa

class PhotoRoomViewController: UIViewController, UIGestureRecognizerDelegate {
    private let viewModel: PhotoViewModel

    init(model: PhotoRoomModel) {
        self.viewModel = PhotoViewModel(model: model)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissToSearchView), for: .touchUpInside)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        let rightButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc private func dismissToSearchView() {
        dismiss(animated: true)
    }
}
