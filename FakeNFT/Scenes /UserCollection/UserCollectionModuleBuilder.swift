import UIKit

final class UserCollectionModuleBuilder {
    static func build(userId: String) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let interactor = UserCollectionInteractor(networkClient: networkClient)
        let router = UserCollectionRouter()
        let view = UserCollectionViewController(userId: userId)
        let presenter = UserCollectionPresenter(
            view: view,
            interactor: interactor,
            router: router,
            userId: userId
        )
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
