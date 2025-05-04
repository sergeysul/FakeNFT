import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var url: String?

    private var webView: WKWebView?
    private var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupActivityIndicator()
        loadWebsite()
    }

    private func setupWebView() {
        let webView = WKWebView(frame: view.frame)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        view.addSubview(webView)
        self.webView = webView
    }

    private func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        self.activityIndicator = activityIndicator
    }

    private func loadWebsite() {
        guard let urlString = url, let webUrl = URL(string: urlString) else {
            showErrorAlert(message: "Некорректная ссылка")
            return
        }

        let request = URLRequest(url: webUrl)
        webView?.load(request)
        activityIndicator?.startAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator?.stopAnimating()
        showErrorAlert(message: "Не удалось загрузить страницу. Проверьте подключение к интернету.")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator?.stopAnimating()
        showErrorAlert(message: "Не удалось открыть сайт. Возможно, он недоступен.")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.stopAnimating()
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
