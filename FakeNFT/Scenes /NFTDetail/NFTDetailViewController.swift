//
//  NFTDetailViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import UIKit

protocol NFTDetailViewProtocol: AnyObject {
}

final class NFTDetailViewController: UIViewController {
    // MARK: - Public
    var presenter: NFTDetailPresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension NFTDetailViewController {
    func initialize() {
    }
}

// MARK: - NFTDetailViewProtocol
extension NFTDetailViewController: NFTDetailViewProtocol {
}
