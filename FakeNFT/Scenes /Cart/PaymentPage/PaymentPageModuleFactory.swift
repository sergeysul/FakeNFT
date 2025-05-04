import UIKit

struct PaymentPageModuleFactory {
    static func build(
        servicesAssembly: ServicesAssembly,
        onPurchase: @escaping () -> Void
    ) -> PaymentPageViewController {
        let interactor = PaymentPageInteractor(serviceAssembly: servicesAssembly)
        let router = PaymentPageRouter()
        let presenter = PaymentPagePresenter(
            interactor: interactor,
            router: router,
            onPurchase: onPurchase
        )
        let viewController = PaymentPageViewController()

        presenter.attachView(viewController)
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
