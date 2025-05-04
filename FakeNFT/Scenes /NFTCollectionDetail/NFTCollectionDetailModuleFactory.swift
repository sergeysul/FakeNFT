import UIKit

struct NFTCollectionDetailModuleFactory {
    static func build(
        input: NftCollectionDetailInput,
        serviceAssembly: ServicesAssembly
    ) -> NFTCollectionDetailViewController {

        let interactor = serviceAssembly.nftCollectionDetailInteractor
        let router = NFTCollectionDetailRouter()
        let presenter = NFTCollectionDetailPresenter(interactor: interactor, router: router, input: input)
        let viewController = NFTCollectionDetailViewController()

        presenter.view = viewController
        viewController.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
