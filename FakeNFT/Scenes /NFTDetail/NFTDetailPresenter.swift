//
//  NFTDetailPresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

protocol NFTDetailPresenterProtocol: AnyObject {
}

final class NFTDetailPresenter {
    weak var view: NFTDetailViewProtocol?
    var router: NFTDetailRouterProtocol
    var interactor: NFTDetailInteractorProtocol

    init(interactor: NFTDetailInteractorProtocol, router: NFTDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension NFTDetailPresenter: NFTDetailPresenterProtocol {
}
