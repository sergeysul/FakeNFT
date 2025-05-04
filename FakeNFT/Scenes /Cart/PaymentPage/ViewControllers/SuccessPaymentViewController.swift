import UIKit

final class SuccessPaymentViewController: UIViewController {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "successPaymentLogo")
        return imageView
    }()

    private let successLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .projectBlack
        return label
    }()

    private lazy var backToCatalogButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .projectBlack
        button.setTitleColor(.projectWhite, for: .normal)
        button.setTitle("Вернуться в каталог", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self,
                         action: #selector(backToCatalogButtonPressed),
                         for: .touchUpInside)
        return button
    }()

    var moveBackAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .projectWhite
        setupConstraints()
    }

    private func setupConstraints() {
        [imageView,
         successLabel,
         backToCatalogButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            imageView.widthAnchor.constraint(equalToConstant: 278),
            imageView.heightAnchor.constraint(equalToConstant: 278),

            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            successLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            successLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),

            backToCatalogButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            backToCatalogButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backToCatalogButton.widthAnchor.constraint(equalToConstant: 343),
            backToCatalogButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc
    private func backToCatalogButtonPressed() {
        dismiss(animated: false) { [weak self] in
            guard let self else { return }
            self.moveBackAction?()
        }
    }
}
