
import UIKit

class CellView: UITableViewCell {
    
    static let imagesCache: NSCache<Item.Token,UIImage> = {
        let cache = NSCache<Item.Token,UIImage>()
        cache.totalCostLimit = 1024*1024;
        return cache
    }()
    
    struct ViewModel {
        let date: String
        let name: String
        let imageData: Data?
        let token: Item.Token
    }

    var viewModel : ViewModel! {
        didSet {
            if let image = CellView.imagesCache.object(forKey: viewModel.token) {
                siteImage.image = image
            } else if let imageData = viewModel.imageData, let image = UIImage(data: imageData) {
                CellView.imagesCache.setObject(image, forKey: viewModel.token, cost: imageData.count)
                siteImage.image = image
            } else {
                siteImage.image = nil
            }
            dateLabel.text = viewModel.date
            nameLabel.text = viewModel.name
        }
    }
    
    @IBOutlet var siteImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func prepareForReuse() {
        siteImage.image = nil
        dateLabel.text = nil
        nameLabel.text = nil
    }
    
}

