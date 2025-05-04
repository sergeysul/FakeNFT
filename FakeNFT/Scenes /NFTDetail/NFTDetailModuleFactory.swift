import UIKit

struct NFTDetailModuleFactory {
    static func build(serviceAssembly: ServicesAssembly) -> NFTDetailViewController {
        let interactor = serviceAssembly.nftDetailInteractor
        let router = NFTDetailRouter()
        let presenter = NFTDetailPresenter(interactor: interactor, router: router)
        let viewController = NFTDetailViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
