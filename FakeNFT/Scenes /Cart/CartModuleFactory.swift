import UIKit

struct CartModuleFactory {
    static func build(servicesAssembly: ServicesAssembly) -> CartViewController {
        let interactor = CartInteractor(serviceAssembly: servicesAssembly)
        let router = CartRouter(serviceAssembly: servicesAssembly)
        let presenter = CartPresenter(interactor: interactor, router: router)
        let viewController = CartViewController()

        presenter.attachView(viewController)
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
