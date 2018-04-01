
import UIKit

class CellView: UITableViewCell {
    
    @IBOutlet var itemImage:  UIImageView!
    @IBOutlet var itemTitle:  UILabel!
    @IBOutlet var itemDetail: UILabel!

    override func prepareForReuse() {
        // view controller creates new rows with no content and updates new cells after scrolling
        // so don't forget to clear dequeued row
        itemImage.image = nil
        itemTitle.text  = nil
        itemDetail.text = nil
    }
    
}

