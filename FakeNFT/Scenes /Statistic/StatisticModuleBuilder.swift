import Foundation

final class StatisticBuilder {
    static func build() -> StatisticViewController {
        let networkClient = DefaultNetworkClient()
        let interactor = StatisticInteractor(networkClient: networkClient)
        let router = StatisticRouter()
        let presenter = StatisticPresenter(interactor: interactor, router: router)
        let viewController = StatisticViewController(presenter: presenter)

        interactor.presenter = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
