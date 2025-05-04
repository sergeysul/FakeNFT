import UIKit

struct NFTCollectionListModuleFactory {
    static func build(serviceAssembly: ServicesAssembly) -> NFTCollectionListViewController {
        let interactor = serviceAssembly.nftCollectionListInteractor
        let router = NFTCollectionListRouter(serviceAssembly: serviceAssembly)
        let presenter = NFTCollectionListPresenter(interactor: interactor, router: router)
        let viewController = NFTCollectionListViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
