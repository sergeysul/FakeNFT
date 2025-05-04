import UIKit

final class DeleteNftFromCartViewController: UIViewController {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()

    private let confirmationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = Localization.deleteNftConfirmationLabel
        label.textColor = UIColor.projectBlack
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.projectBlack
        button.setTitle(Localization.delete, for: .normal)
        button.setTitleColor(UIColor.redUniversal, for: .normal)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.projectBlack
        button.setTitle(Localization.getBack, for: .normal)
        button.setTitleColor(UIColor.projectWhite, for: .normal)
        return button
    }()

    private var deleteAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func configure(
        imageUrlString: String,
        deleteAction: @escaping () -> Void
    ) {
        self.deleteAction = deleteAction
        deleteButton.addTarget(
            self,
            action: #selector(deleteButtonTapped),
            for: .touchUpInside
        )
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        ImageFetcher.shared.fetchImage(from: imageUrlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupUI() {
        setupBlur()
        setupConstraints()
    }

    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)

        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
    }

    private func setupConstraints() {
        [imageView,
         confirmationLabel,
         deleteButton,
         cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            confirmationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            confirmationLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            confirmationLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),

            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: confirmationLabel.topAnchor, constant: -12),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.heightAnchor.constraint(equalToConstant: 108),

            deleteButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            deleteButton.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),

            cancelButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            cancelButton.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc
    private func deleteButtonTapped() {
        deleteAction?()
        dismiss(animated: true)
    }

    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
