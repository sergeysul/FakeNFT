//
//  AuthorPageModuleFactory.swift
//  Super easy dev
//
//  Created by Nikolay on 24.02.2025
//

import Foundation

struct AuthorPageModuleFactory {
    static func build(url: URL) -> AuthorPageViewController {

        let presenter = AuthorPagePresenter(url: url)
        let viewController = AuthorPageViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        return viewController
    }
}
