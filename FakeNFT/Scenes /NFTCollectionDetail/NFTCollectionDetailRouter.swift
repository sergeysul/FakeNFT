//
//  NFTCollectionDetailRouter.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

import UIKit

protocol NFTCollectionDetailRouterProtocol {
    func showAuthorPage(url: URL?)
}

final class NFTCollectionDetailRouter: NFTCollectionDetailRouterProtocol {
    weak var viewController: NFTCollectionDetailViewController?

    func showAuthorPage(url: URL?) {
        guard let url = url else { return }
        let authorViewController = AuthorPageModuleFactory.build(url: url)
        if let navigationViewController = viewController?.parent as? UINavigationController {
            navigationViewController.pushViewController(authorViewController, animated: true)
        }
    }
}
