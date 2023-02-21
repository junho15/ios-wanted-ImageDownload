import UIKit

// MARK: - Properties

final class ViewController: UIViewController {
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var progressViews: [UIProgressView]!
    @IBOutlet var loadButtons: [UIButton]!

    let imageURLs = [
        "https://wallpaperaccess.com/download/europe-4k-1369012",
        "https://wallpaperaccess.com/download/europe-4k-1318341",
        "https://wallpaperaccess.com/download/europe-4k-1379801",
        "https://wallpaperaccess.com/download/cool-lion-167408",
        "https://wallpaperaccess.com/download/ironman-hd-323408"]
}

// MARK: - Methods

extension ViewController {
    private func buttonIndex(of button: UIButton) -> Int? {
        return loadButtons.firstIndex(where: { $0 == button })
    }

    private func clearImageView(for index: Int) {
        imageViews[index].image = UIImage(systemName: "photo")
    }

    private func setupImageView(_ image: UIImage?, for index: Int) {
        imageViews[index].image = image
    }
}

// MARK: - Button Actions

extension ViewController {
    @IBAction private func touchUpLoadButton(_ sender: UIButton) {
        guard let index = buttonIndex(of: sender),
              let imageURL = URL(string: imageURLs[index]) else { return }
        clearImageView(for: index)

        let imageLoadOperation = ImageLoadOperation(imageURL: imageURL)
        imageLoadOperation.completionBlock = {
            OperationQueue.main.addOperation {
                self.setupImageView(imageLoadOperation.image, for: index)
            }
        }

        let loadQueue = OperationQueue()
        loadQueue.addOperation(imageLoadOperation)
    }

    @IBAction func touchUpLoadAllButton(_ sender: UIButton) {
        var imageLoadOperations = [Operation]()

        imageURLs.enumerated().forEach { index, imageURL in
            guard let imageURL = URL(string: imageURLs[index]) else { return }
            clearImageView(for: index)

            let imageLoadOperation = ImageLoadOperation(imageURL: imageURL)
            imageLoadOperation.completionBlock = {
                OperationQueue.main.addOperation {
                    self.setupImageView(imageLoadOperation.image, for: index)
                }
            }
            imageLoadOperations.append(imageLoadOperation)
        }

        let loadQueue = OperationQueue()
        loadQueue.addOperations(imageLoadOperations, waitUntilFinished: false)
    }
}
