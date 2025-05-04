//
//  AuthorPageViewController.swift
//  Super easy dev
//
//  Created by Nikolay on 24.02.2025
//

import UIKit
import WebKit

protocol AuthorPageViewProtocol: AnyObject {
}

final class AuthorPageViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    // MARK: - Public
    var presenter: AuthorPagePresenterProtocol?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebViewContent()
        initialize()
    }

    private func loadWebViewContent() {

        guard let urlRequest = presenter?.makeAuthorPageURLRequest() else {
            return
        }
        DispatchQueue.main.async {
            self.webView.load(urlRequest)
        }
    }
}

// MARK: - Private functions
private extension AuthorPageViewController {
    func initialize() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - AuthorPageViewProtocol
extension AuthorPageViewController: AuthorPageViewProtocol {
}
