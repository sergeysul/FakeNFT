import UIKit

final class RatingView: UIView {

    // MARK: - UI Elements

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 2
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var starImageViews: [UIImageView] = []

    // MARK: - Properties

    var rating: Int = 0 {
        didSet {
            updateStars()
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        setupStackView()
        setupStars()
        updateStars()
    }

    private func setupStackView() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 68),
            stackView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    private func setupStars() {
        for _ in 0..<5 {
            let starImageView = createStarImageView()
            starImageViews.append(starImageView)
            stackView.addArrangedSubview(starImageView)
        }
    }

    private func createStarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "starInactive")
        return imageView
    }

    // MARK: - Update Stars

    private func updateStars() {
        for (index, imageView) in starImageViews.enumerated() {
            imageView.image = index < rating
                ? UIImage(named: "starActive")
                : UIImage(named: "starInactive")
            imageView.tintColor = .yellow
        }
    }
}
