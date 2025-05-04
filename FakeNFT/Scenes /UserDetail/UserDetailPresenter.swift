import UIKit

protocol UserDetailPresenterProtocol: AnyObject {
    func loadUserDetails()
    func openWebsite()
    func openCollection()
}

final class UserDetailPresenter: UserDetailPresenterProtocol {

    weak var view: UserDetailViewProtocol?
    private let interactor: UserDetailInteractorProtocol
    private let router: UserDetailRouterProtocol
    private let userId: String
    private var userDetail: UserDetail?

    init(
        view: UserDetailViewProtocol,
        interactor: UserDetailInteractorProtocol,
        router: UserDetailRouterProtocol,
        userId: String
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.userId = userId
    }

    func loadUserDetails() {
        view?.showLoadingIndicator()
        interactor.fetchUserDetail(userId: userId)
    }

    func openWebsite() {
        guard let user = userDetail, !user.website.isEmpty else { return }
        router.openWebsite(url: user.website)
    }

    func openCollection() {
        guard let user = userDetail else { return }
        router.openCollection(userId: user.id)
    }

    private func prepareUserDetails(_ user: UserDetail) -> UserDetails {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]

        let attributedDescription = NSAttributedString(string: user.description, attributes: attributes)
        let collectionText = "Коллекция NFT (\(user.nftCount))"
        let imageUrl = URL(string: user.avatar)

        return UserDetails(
            name: user.name,
            description: attributedDescription,
            text: collectionText,
            imageURL: imageUrl
        )
    }
}

extension UserDetailPresenter: UserDetailInteractorOutputProtocol {
    func didFetchUserDetail(_ user: UserDetail) {
        self.userDetail = user
        let userDetails = prepareUserDetails(user)

        view?.updateUserDetails(name: userDetails.name,
                                description: userDetails.description,
                                collectionText: userDetails.text,
                                image: UIImage(named: "placeholder"))

        if let imageUrl = userDetails.imageURL {
            ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
                self?.view?.updateUserImage(image)
            }
        }
        view?.hideLoadingIndicator()
    }

    func didFailFetchingUserDetail(with error: Error) {
        view?.hideLoadingIndicator()
        print("Ошибка загрузки пользователя: \(error.localizedDescription)")
    }
}
