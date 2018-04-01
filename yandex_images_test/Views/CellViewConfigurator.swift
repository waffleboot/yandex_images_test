
import UIKit

class CellViewConfigurator {
    
    let imagesCache: NSCache<Item.Token,UIImage> = {
        let cache = NSCache<Item.Token,UIImage>()
        cache.totalCostLimit = 1024*1024;
        return cache
    }()
    
    func didReceiveMemoryWarning() {
        imagesCache.removeAllObjects()
    }

    func configure(_ cell: CellView, forItem item: Item) {
        if let image = imagesCache.object(forKey: item.token) {
            cell.itemImage.image = image
        } else if let imageData = item.image, let image = UIImage(data: imageData) {
            imagesCache.setObject(image, forKey: item.token, cost: imageData.count)
            cell.itemImage.image = image
        } else {
            cell.itemImage.image = nil
        }
        cell.itemTitle.text  = dateFormatter.string(from: item.date)
        cell.itemDetail.text = item.name
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

}
