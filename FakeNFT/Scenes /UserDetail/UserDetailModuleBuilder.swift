import UIKit

final class UserDetailModuleBuilder {
    static func build(userId: String) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let interactor = UserDetailInteractor(networkClient: networkClient)
        let router = UserDetailRouter()
        let view = UserDetailViewController()
        let presenter = UserDetailPresenter(
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
