import UIKit

// MARK: - Protocol
protocol CartViewProtocol: AnyObject {
    func showNfts(totalPrice: String, numberOfItems: String)
    func reloadTable()
    func showLoader()
    func hideLoader()
    func showPlaceholder()
}

// MARK: - CartViewController
final class CartViewController: UIViewController {

    // MARK: - Public Properties
    var presenter: CartPresenterProtocol?

    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.allowsSelection = false
        tableView.backgroundColor = .projectWhite
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let paymentBlockView: PaymentBlockView = {
        let view = PaymentBlockView()
        view.isHidden = true
        return view
    }()

    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .projectBlack
        label.isHidden = true
        label.textAlignment = .center
        label.text = "Корзина пуста"
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getOrder()
    }
}

// MARK: - Private Methods
private extension CartViewController {
    func setupUI() {
        setupNavBar()
        setupTableView()
        setupConstraints()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .projectWhite
    }

    func setupNavBar() {
        let filterButton = UIBarButtonItem(
            image: UIImage(named: "filterIcon"),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.projectBlack
        filterButton.tintColor = UIColor.projectBlack
        navigationItem.rightBarButtonItem = filterButton
    }

    func setupTableView() {
        tableView.delegate = presenter
        tableView.dataSource = presenter
    }

    func setupConstraints() {
        [tableView,
         paymentBlockView,
         activityIndicator,
         emptyCartLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),

            paymentBlockView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            paymentBlockView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentBlockView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentBlockView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCartLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyCartLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
        ])
    }

    @objc
    func filterButtonTapped() {
        presenter?.showFilters()
    }
}

// MARK: - CartViewProtocol
extension CartViewController: CartViewProtocol {
    private func toggleVisibility(isTableViewVisible: Bool) {
        tableView.isHidden = !isTableViewVisible
        emptyCartLabel.isHidden = isTableViewVisible
        paymentBlockView.isHidden = !isTableViewVisible
    }

    func showNfts(totalPrice: String, numberOfItems: String) {
        paymentBlockView.configure(
            totalPrice: totalPrice,
            numberOfItems: numberOfItems
        ) { [weak self] in
            self?.presenter?.showPayment()
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        toggleVisibility(isTableViewVisible: true)
    }

    func reloadTable() {
        tableView.reloadData()
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

    func showPlaceholder() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        toggleVisibility(isTableViewVisible: false)
    }
}
