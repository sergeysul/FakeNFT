import UIKit

protocol UserCollectionViewProtocol: AnyObject {
    func showNFTs(_ nfts: [NFT])
    func showError(_ error: Error)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class UserCollectionViewController: UIViewController {
    private let userId: String
    private var nfts: [NFT] = []
    var presenter: UserCollectionPresenterProtocol?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 28
        layout.itemSize = CGSize(width: 108, height: 172)

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        initialize()
        presenter?.viewDidLoad()
    }

    private func initialize() {
        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UserCollectionViewCell.self,
            forCellWithReuseIdentifier: UserCollectionViewCell.reuseIdentifier
        )
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    private func setupNavigationBar() {
        self.title = "Коллекция NFT"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
            .foregroundColor: UIColor.black
        ]
    }
}

extension UserCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserCollectionViewCell else {
            print("Ошибка: не удалось создать ячейку")
            return UICollectionViewCell()
        }

        let nft = nfts[indexPath.row]
        cell.configure(with: nft, cart: presenter?.cart, profile: presenter?.profile)
        return cell
    }
}

extension UserCollectionViewController: UserCollectionViewProtocol {
    func showNFTs(_ nfts: [NFT]) {
        self.nfts = nfts
        collectionView.reloadData()
    }

    func showError(_ error: Error) {
        print("Ошибка: \(error.localizedDescription)")
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
}
