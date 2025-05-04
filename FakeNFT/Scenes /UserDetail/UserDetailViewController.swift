import UIKit

protocol UserDetailViewProtocol: AnyObject {
    func updateUserDetails(name: String, description: NSAttributedString, collectionText: String, image: UIImage?)
    func updateUserImage(_ image: UIImage?)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class UserDetailViewController: UIViewController, UserDetailViewProtocol {

    var presenter: UserDetailPresenterProtocol?

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 16.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let collectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let collectionIcon: UIImageView = {
        let imageView = UIImageView()
        if let arrowImage = UIImage(named: "chevronRight")?.withRenderingMode(.alwaysTemplate) {
            imageView.image = arrowImage
        }
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var collectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionLabel, collectionIcon])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let collectionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.loadUserDetails()

        websiteButton.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCollection))
        collectionContainer.addGestureRecognizer(tapGesture)
        navigationItem.backButtonTitle = ""
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(collectionContainer)
        collectionContainer.addSubview(collectionStackView)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),

            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            websiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),

            collectionContainer.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 56),
            collectionContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionContainer.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            collectionContainer.heightAnchor.constraint(equalToConstant: 40),

            collectionStackView.centerYAnchor.constraint(equalTo: collectionContainer.centerYAnchor),
            collectionStackView.leadingAnchor.constraint(equalTo: collectionContainer.leadingAnchor),
            collectionStackView.trailingAnchor.constraint(equalTo: collectionContainer.trailingAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func updateUserDetails(name: String, description: NSAttributedString, collectionText: String, image: UIImage?) {
        nameLabel.text = name
        descriptionLabel.attributedText = description
        collectionLabel.text = collectionText
        avatarImageView.image = image
    }

    func updateUserImage(_ image: UIImage?) {
        avatarImageView.image = image
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    @objc private func openWebsite() {
        presenter?.openWebsite()
    }

    @objc private func openCollection() {
        presenter?.openCollection()
    }
}
