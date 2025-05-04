protocol PaymentPageRouterProtocol {
    func showWebView()
    func showSuccessPaymentView(moveBackAction: @escaping () -> Void)
}

class PaymentPageRouter: PaymentPageRouterProtocol {
    weak var viewController: PaymentPageViewController?

    func showWebView() {
        let webVC = WebViewViewController(url: "https://practicum.yandex.ru/")
        webVC.modalPresentationStyle = .pageSheet
        viewController?.present(webVC, animated: true)
    }

    func showSuccessPaymentView(moveBackAction: @escaping () -> Void) {
        let successVC = SuccessPaymentViewController()
        successVC.moveBackAction = moveBackAction
        successVC.modalPresentationStyle = .overFullScreen
        viewController?.present(successVC, animated: true)
    }
}
