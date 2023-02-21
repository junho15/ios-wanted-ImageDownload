import UIKit

final class ImageLoadOperation: Operation {
    var imageURL: URL?
    var image: UIImage?

    init(imageURL: URL? = nil) {
        self.imageURL = imageURL
    }

    override func main() {
        guard let imageURL else { return }
        if let data = try? Data(contentsOf: imageURL),
           let image = UIImage(data: data) {
            self.image = image
        }
    }
}
