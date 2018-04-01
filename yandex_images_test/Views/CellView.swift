
import UIKit

class CellView: UITableViewCell {
    
    @IBOutlet var itemImage:  UIImageView!
    @IBOutlet var itemTitle:  UILabel!
    @IBOutlet var itemDetail: UILabel!

    struct ViewModel {
        let title: String
        let detail: String
        let imageData: Data?
        let token: Item.Token
    }
    
    func configure(_ viewModel: ViewModel) {
        if let image = CellView.imagesCache.object(forKey: viewModel.token) {
            itemImage.image = image
        } else if let imageData = viewModel.imageData, let image = UIImage(data: imageData) {
            CellView.imagesCache.setObject(image, forKey: viewModel.token, cost: imageData.count)
            itemImage.image = image
        } else {
            itemImage.image = nil
        }
        itemTitle.text = viewModel.title
        itemDetail.text = viewModel.detail
    }

    override func prepareForReuse() {
        // view controller creates new rows with no content and updates new cells after scrolling
        // so don't forget to clear dequeued row
        itemImage.image = nil
        itemTitle.text  = nil
        itemDetail.text = nil
    }
    
}

extension CellView {

    static let imagesCache: NSCache<Item.Token,UIImage> = {
        let cache = NSCache<Item.Token,UIImage>()
        cache.totalCostLimit = 1024*1024;
        return cache
    }()

}
