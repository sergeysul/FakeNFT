import Foundation

protocol StatisticRouterProtocol {
    func showUserDetail(userId: String)
}

class StatisticRouter: StatisticRouterProtocol {
    weak var viewController: StatisticViewController?

    func showUserDetail(userId: String) {
        let userDetailVC = UserDetailModuleBuilder.build(userId: userId)
        viewController?.navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
