//
//  AuthorPagePresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 24.02.2025
//

import Foundation

protocol AuthorPagePresenterProtocol: AnyObject {
    func makeAuthorPageURLRequest() -> URLRequest
}

final class AuthorPagePresenter {
    weak var view: AuthorPageViewProtocol?
    private var authorPageURL: URL

    init(url: URL) {
        self.authorPageURL = url
    }
}

extension AuthorPagePresenter: AuthorPagePresenterProtocol {

    func makeAuthorPageURLRequest() -> URLRequest {
        return URLRequest(url: authorPageURL)
    }
}
