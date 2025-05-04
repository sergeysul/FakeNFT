import Foundation
import WebKit

protocol UserDetailRouterProtocol {
    func openWebsite(url: String)
    func openCollection(userId: String)
}

class UserDetailRouter: UserDetailRouterProtocol {
    weak var viewController: UIViewController?

    func openWebsite(url: String) {
        let webViewController = WebViewController()
        webViewController.url = url
        viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }

    func openCollection(userId: String) {
        let collectionVC = UserCollectionModuleBuilder.build(userId: userId)
        viewController?.navigationController?.pushViewController(collectionVC, animated: true)
    }
}
