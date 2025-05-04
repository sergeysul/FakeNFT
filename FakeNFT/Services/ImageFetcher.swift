import UIKit
import Kingfisher

enum ImageFetcherError: Error {
    case invalidURL
}

class ImageFetcher {
    static let shared = ImageFetcher()
    private let cache = ImageCache.default
    private let placeholderImage = UIImage(named: "placeholder")

    private init() {}

    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.success(placeholderImage ?? UIImage()))
            return
        }

        let cacheKey = urlString

        cache.retrieveImage(forKey: cacheKey) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    completion(.success(image))
                    return
                }
            case .failure:
                break
            }

            KingfisherManager.shared.retrieveImage(with: url, options: [.cacheOriginalImage]) { result in
                switch result {
                case .success(let value):
                    completion(.success(value.image))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
