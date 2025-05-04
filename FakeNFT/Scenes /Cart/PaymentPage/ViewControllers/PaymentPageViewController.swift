import UIKit

protocol PaymentPageViewProtocol: UIViewController {
    func showCollection()
    func showLoader()
    func hideLoader()
    func reloadCollection()
}

class PaymentPageViewController: UIViewController {
    // MARK: - Public
    var presenter: PaymentPagePresenterProtocol?

    private let agreementAndPayView = AgreementAndPayView()

    private enum LayoutConstants {
        static let columns: CGFloat = 2
        static let interItemSpacing: CGFloat = 7
        static let lineSpacing: CGFloat = 7
        static let sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let itemHeight: CGFloat = 46
    }

    private lazy var currencyCollectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.projectWhite
        collectionView.layer.cornerRadius = 12
        collectionView.isHidden = true
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension PaymentPageViewController {
    func initialize() {
        view.backgroundColor = UIColor.projectWhite
        navigationItem.title = Localization.paymentPageTitle
        agreementAndPayView.presenter = presenter
        setupConstraints()
        setupCurrencyCollectionView()
    }

    func setupCurrencyCollectionView() {
        currencyCollectionView.register(PaymentMethodCollectionViewCell.self)
        currencyCollectionView.dataSource = presenter
        currencyCollectionView.delegate = presenter
    }

    func setupConstraints() {
        [agreementAndPayView,
         activityIndicator,
         currencyCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            agreementAndPayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            agreementAndPayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            agreementAndPayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            agreementAndPayView.heightAnchor.constraint(equalToConstant: 186),

            currencyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currencyCollectionView.bottomAnchor.constraint(equalTo: agreementAndPayView.topAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: currencyCollectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: currencyCollectionView.centerYAnchor)
        ])

        if let layout = currencyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let columns: CGFloat = 2
            let totalSpacing: CGFloat = 7 * (columns - 1) + 16 * 2
            let itemWidth = (view.frame.width - totalSpacing) / columns
            layout.itemSize = CGSize(width: itemWidth, height: 46)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }

    func createCollectionViewLayout() -> UICollectionViewLayout {
        if #available(iOS 13.0, *) {
            return createCompositionalLayout()
        } else {
            return createFlowLayout()
        }
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(LayoutConstants.itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(LayoutConstants.itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: Int(LayoutConstants.columns)
        )
        group.interItemSpacing = .fixed(LayoutConstants.interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = LayoutConstants.lineSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: LayoutConstants.sectionInset.top,
            leading: LayoutConstants.sectionInset.left,
            bottom: LayoutConstants.sectionInset.bottom,
            trailing: LayoutConstants.sectionInset.right
        )

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = LayoutConstants.lineSpacing
        layout.minimumInteritemSpacing = LayoutConstants.interItemSpacing
        layout.sectionInset = LayoutConstants.sectionInset
        return layout
    }

    func updateCollectionViewLayout() {
        guard let layout = currencyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let totalHorizontalInset = LayoutConstants.sectionInset.left + LayoutConstants.sectionInset.right
        let totalSpacing = LayoutConstants.interItemSpacing * (LayoutConstants.columns - 1)
        let availableWidth = currencyCollectionView.bounds.width - totalHorizontalInset - totalSpacing
        let itemWidth = floor(availableWidth / LayoutConstants.columns)

        layout.itemSize = CGSize(width: itemWidth, height: LayoutConstants.itemHeight)
        layout.invalidateLayout()
    }
}

// MARK: - PaymentPageViewProtocol
extension PaymentPageViewController: PaymentPageViewProtocol {
    func showCollection() {
        currencyCollectionView.isHidden = false
        currencyCollectionView.reloadData()
    }

    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.bringSubviewToFront(self.activityIndicator)
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func reloadCollection() {
        currencyCollectionView.reloadData()
    }
}
