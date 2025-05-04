import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Properties

    private let servicesAssembly: ServicesAssembly

    // MARK: - Init

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Tab Bar Items

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cartTabBarIcon"),
        tag: 2
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "CatalogTabbarImage"),
        tag: 0
    )

    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(named: "statisticTab"),
        tag: 1
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    // MARK: - Setup Methods

    private func setupTabBar() {
        let catalogNavController = createNavController(
            rootViewController: NFTCollectionListModuleFactory.build(serviceAssembly: servicesAssembly),
            tabBarItem: catalogTabBarItem
        )

        let statisticNavController = createNavController(
            rootViewController: StatisticBuilder.build(),
            tabBarItem: statisticTabBarItem
        )
        configureStatisticNavigationBar(statisticNavController)

        let cartNavController = createNavController(
            rootViewController: CartModuleFactory.build(servicesAssembly: servicesAssembly),
            tabBarItem: cartTabBarItem
        )

        viewControllers = [catalogNavController, cartNavController, statisticNavController]
        view.backgroundColor = .systemBackground
    }

    private func createNavController(
        rootViewController: UIViewController,
        tabBarItem: UITabBarItem
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }

    private func configureStatisticNavigationBar(_ navigationController: UINavigationController) {
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.frame.size.height = 42
    }
}
